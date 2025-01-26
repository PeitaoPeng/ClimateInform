PROGRAM Neural_Simulator

!! change data I/O

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!! Neural Network in Fortran90
!! Multilayer Perceptron trained with
!! the backpropagation learning algorithm
!! coded in Fortran90 by Phil Brierley
!! www.philbrierley.com
!! this code may be used and modified at will
!! compiled using Compaq Visual Fortran
!!-------------------------------------------------------
!! This code reads in data from a csv text file
!! For the neural network training process follow
!! the code in the subroutine 'sTrain_Net'
!! most of the other code is for the data handling
!!-------------------------------------------------------
!! modifications recommended:
!!
!! 1)
!! The data is split into a train,test & validation set.
!! The final model weights should be the best on the test
!! set.
!!
!! 2)
!! The reported errors are based on the normalised data
!! values. These could be scaled up to give actual errors
!!
!!-------------------------------------------------------
!! prefix logic
!! a = array
!! i = integer 
!! r = real
!! l = logical
!! c = character
!! f = function
!! s = subroutine
!! g = global variable
!!-------------------------------------------------------
!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

!we must declare all our variables
IMPLICIT NONE
INTEGER :: iFILEROWS,iDATAFIELDS
INTEGER :: iTRAINPATS, iTESTPATS, iVALIDPATS
INTEGER :: iEPOCHS, iHIDDDEN0, iHIDDDEN
INTEGER :: iREDISPLAY
REAL :: ra
!! include parameters assigned in script file
      include "parm.h"

!-------------------------------------
!    declarations
!-------------------------------------

!used for checking user input from keyboard
!the value may be compiler dependent so is set here
INTEGER :: giIOERR_OK = 0

!a handle on the opened source data file
INTEGER, PARAMETER :: giUNITIN = 10        !! input data unit
INTEGER, PARAMETER :: giUNIT_TRAIN = 20  !! out for prd in train
INTEGER, PARAMETER :: giUNIT_TEST = 30   !! out for prd in test
INTEGER, PARAMETER :: giUNIT_VAL = 40    !! out for prd in validation

  
!-------------------------------------
!    declare arrays
!-------------------------------------

!data arrays
REAL,ALLOCATABLE :: garDataArray(:,:),garDataArray2(:,:)
REAL,ALLOCATABLE :: garTrainingInputs(:,:),garTrainingOutputs(:)
REAL,ALLOCATABLE :: garTestingInputs(:,:),garTestingOutputs(:)
REAL,ALLOCATABLE :: garValidationInputs(:,:),garValidationOutputs(:)
REAL,ALLOCATABLE :: garInputs_this_pattern(:)

! array for write out
REAL,ALLOCATABLE :: gaWOUT_TRAIN(:), gaWOUT_TEST(:), gaWOUT_VAL(:)

!weight arrays
REAL,ALLOCATABLE :: garWIH(:,:),garWIH_Best(:,:)
REAL,ALLOCATABLE :: garWHO(:),garWHO_Best(:)
!you might also want to save the best test set weights!


!neuron outputs
REAL,ALLOCATABLE :: garHVAL(:)

!dummy arrays used in matrix multiplication
REAL,ALLOCATABLE :: garDUMMY1(:,:),garDUMMY2(:,:)

!max and min values of each field
!use these to scale up the reported errors
REAL,ALLOCATABLE :: garMaxInp(:),garMinInp(:)
REAL             :: grMaxOut, grMinOut



!-------------------------------------
!    declare other system variables
!-------------------------------------

!network topolgy numbering (dependent on number of hidden neurons)
INTEGER :: giNHS                        !Number Hidden Start
INTEGER :: giNHF                        !Number Hidden Finish
INTEGER :: giNOS                        !Number Output Start

!general network numbering (independent of number of hidden neurons)
INTEGER :: giINPPB              !INPputs Plus Bias
INTEGER :: giINPUTS
INTEGER :: iOUTPUTS
INTEGER :: giNDU                !Number Data Units

!information about the source data file
INTEGER :: giDATAFIELDS = iDATAFIELDS
INTEGER :: giFILEROWS = iFILEROWS

!number of patterns
INTEGER :: giPATS
INTEGER :: giTRAINPATS = iTRAINPATS
INTEGER :: giTESTPATS = iTESTPATS
INTEGER :: giVALIDPATS = iVALIDPATS

!errors
REAL    :: grRMSE,grRMSEBEST,grRMSETEST


!-------------------------------------
!    user set variables
!-------------------------------------

!number of hidden neurons
INTEGER :: giHIDDDEN0 = iHIDDDEN
INTEGER :: giHIDDDEN
        
!number of epochs to train for
INTEGER :: giEPOCHS = iEPOCHS

!learning rates
REAL    :: grALR = ra
REAL    :: grBLR

!how often progress is output to screen
INTEGER :: giREDISPLAY = iREDISPLAY

INTEGER :: it, iy, itgt

!-------------------------------------
!   main routine
!-------------------------------------
    ! setup parameters & read in data 
      CALL sSetUp_1

    ! arrange data for CV
      DO itgt = 1, giFILEROWS

        PRINT *,'itgt=',itgt
        PRINT *,'start reading data'

        it = 0
        DO iy = 1, giFILEROWS 

        if(iy.eq.itgt)  go to 555

        it = it + 1

        garDataArray(it, 1:giNDU) = garDataArray2(iy, 1:giNDU)

  555   CONTINUE
        ENDDO  ! iy loop

        garDataArray(giFILEROWS,1:giNDU) = garDataArray2(itgt,1:giNDU)

        PRINT *,'finished reading data'

    ! setup arrays 
      CALL sSetUp_2

    ! neural network training
      CALL sTrain_Net(giEPOCHS,grALR,giIOERR_OK)

    ! delocate Weight_Arrays
      CALL sDeAllocate_Weight_Arrays

      ENDDO  ! itgt loop

        PRINT *,'BYE!'

!-------------------------------------
!    end of main routine
!-------------------------------------

!-------------------------------------
!   all the functions and subroutines
!-------------------------------------

CONTAINS

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!   THE MAIN NEURAL NETWORK LEARNING SUBS       !!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!


SUBROUTINE sTrain_Net(giEPOCHS,grALR,iIOERR_OK)

INTEGER, INTENT(IN) ::  iIOERR_OK
INTEGER, INTENT(IN) ::  giEPOCHS
REAL, INTENT(IN) :: grALR
REAL ::  grBLR
INTEGER :: I,J,iPAT_NUM 
REAL    :: rOUTPUT_THIS_PAT, rOUTPRED, rER_THIS_PAT
REAL    :: rRAND

        !have the learning rates
        grBLR = grALR/10.

        !set how often the errors will be output to screen

        !do the required number of epochs
        doEpochs: DO J=1,giEPOCHS 

                !an epoch is when every pattern has been seen once
                doPats: DO I=1,giTRAINPATS  
                        
                        !! select a pattern at random
                        CALL RANDOM_NUMBER(rRAND)
                        iPAT_NUM=NINT(rRAND*(giTRAINPATS-1))+1

                        !! set the data to this pattern
                        garInputs_this_pattern(:)=garTrainingInputs(iPAT_NUM,:)
                        rOUTPUT_THIS_PAT=garTrainingOutputs(iPAT_NUM)

                        !! calculate the current error          
                        rER_THIS_PAT= frCalc_Err_This_Pat &
                        (garInputs_this_pattern,rOUTPUT_THIS_PAT,garWIH,garWHO)

                        !! change weight hidden - output
                        garWHO=garWHO-(grBLR*garHVAL*rER_THIS_PAT)

                        !! change weight input - hidden 
                        garDUMMY2(:,1)=garTrainingInputs(iPAT_NUM,:) 
                        garDUMMY1(1,:)=rER_THIS_PAT*garWHO*(1-(garHVAL**2.00))
                        garWIH=garWIH-(MATMUL(garDUMMY2,garDUMMY1)*grALR)

                ENDDO doPats ! one more epoch done


                !!  evaluate  'fitness' of of the network  after each
                !epoch
                grRMSE = frCalculate_Error &
                (garTrainingInputs,garTrainingOutputs, garWIH, garWHO)

                !keep the new weights if an improvement has been made
                Call sKeep_Best_Weights(J)

                !! print errors to screen !!
                CALL sDisplay_Progress(J)


        ENDDO doEpochs
        
        ! print final errors to screen
        CALL sDisplay_Errors

END SUBROUTINE sTrain_Net



REAL FUNCTION frCalc_Err_This_Pat(arINPS_TP,rOUTPUT_TP,arWIHL,arWHOL)
! calculate the error on a specific pattern

        REAL,   DIMENSION(:),   INTENT(IN)      :: arINPS_TP
        REAL,   DIMENSION(:,:), INTENT(IN)      :: arWIHL
        REAL,   DIMENSION(:),   INTENT(IN)      :: arWHOL
        REAL,   INTENT(IN)      :: rOUTPUT_TP

        REAL :: rOUTPREDL

        garHVAL=TANH(MATMUL(TRANSPOSE(arWIHL),arINPS_TP))
        garHVAL(UBOUND(garHVAL,1)) = 1
        rOUTPREDL=SUM(arWHOL*garHVAL)
        frCalc_Err_This_Pat =(rOUTPREDL-rOUTPUT_TP)


END FUNCTION frCalc_Err_This_Pat



REAL FUNCTION frCalculate_Error(arINPS,arOUT,arWIHL, arWHOL)
! calculate the overall error

        REAL, DIMENSION(:,:),   INTENT(IN)      :: arINPS
        REAL, DIMENSION(:),     INTENT(IN)      :: arOUT
        REAL, DIMENSION(:,:),   INTENT(INOUT)   :: arWIHL
        REAL, DIMENSION(:),     INTENT(INOUT)   :: arWHOL       

        REAL, DIMENSION(LBOUND(arINPS,2):UBOUND(arINPS,2)) :: arINPUTS_THIS_PAT
        REAL :: rSQERROR, rOUTPUT_THIS_PAT, rER_THIS_PAT

        INTEGER :: I,iLOWER,iUPPER

        iLOWER = LBOUND(arINPS,1)
        iUPPER = UBOUND(arINPS,1)

        ! in this case the fitness function is the squared errors
        rSQERROR=0.0            

        DO I=iLOWER,iUPPER
                rOUTPUT_THIS_PAT = arOUT(I)
                arINPUTS_THIS_PAT(:)= arINPS(I,:)
                rER_THIS_PAT= frCalc_Err_This_Pat &
                (arINPUTS_THIS_PAT,rOUTPUT_THIS_PAT,arWIHL,arWHOL)
                rSQERROR=rSQERROR+(rER_THIS_PAT**2)
        ENDDO

        ! root of the mean squared error
        frCalculate_Error=SQRT(rSQERROR/(iUPPER-iLOWER+1))      

END FUNCTION frCalculate_Error

SUBROUTINE sCalculate_AC(arINPS,arOUT,arWIHL, arWHOL, &
rAC, rSTDO, rSTDP,iUNIT,WOUT,NT)
! calculate the overall error

        REAL, DIMENSION(:,:),   INTENT(IN)      :: arINPS
        REAL, DIMENSION(:),     INTENT(IN)      :: arOUT
        REAL, DIMENSION(:,:),   INTENT(INOUT)   :: arWIHL
        REAL, DIMENSION(:),     INTENT(INOUT)   :: arWHOL       

        REAL, DIMENSION(LBOUND(arINPS,2):UBOUND(arINPS,2)) :: arINPUT
        REAL :: rOUTPUT, rOUTPRD
        REAL, INTENT(INOUT) :: rAC, rSTDO, rSTDP

        INTEGER :: I, J, iLOWER, iUPPER
        INTEGER :: iUNIT, NT
        REAL :: WOUT(NT)   

        iLOWER = LBOUND(arINPS,1)
        iUPPER = UBOUND(arINPS,1)

        rAC=0.0            
        rSTDP=0.0            
        rSTDO=0.0            

        J=0
        DO I=iLOWER,iUPPER
             rOUTPUT = arOUT(I)
             arINPUT(:)= arINPS(I,:)
             garHVAL=TANH(MATMUL(TRANSPOSE(arWIHL),arINPUT))
             garHVAL(UBOUND(garHVAL,1)) = 1
             rOUTPRD=SUM(arWHOL*garHVAL)
             rAC=rAC+rOUTPUT*rOUTPRD
             rSTDO=rSTDO + rOUTPUT**2
             rSTDP=rSTDP + rOUTPRD**2
             J = J + 1
             WOUT(J)=rOUTPRD
        ENDDO

!! temporal anomaly correlation
        rSTDO=SQRT(rSTDO/(iUPPER-iLOWER+1))
        rSTDP=SQRT(rSTDP/(iUPPER-iLOWER+1))
        rAC=rAC/(iUPPER-iLOWER+1)
        rAC=rAC/(rSTDO*rSTDP)

!! write out prd
        CALL sScale_Prd(NT, WOUT)
        CALL sWrite_Out(iUNIT,NT,WOUT)

END SUBROUTINE sCalculate_AC



SUBROUTINE sKeep_Best_Weights(iEpch)
! if the overall error has improved then keep the new weights

        INTEGER, INTENT(IN) :: iEpch

        !this will be on the first epoch
        IF (iEpch .EQ. 1) THEN
                grRMSEBEST = grRMSE
        ENDIF

        IF (grRMSE < grRMSEBEST) THEN
                garWIH_Best = garWIH
                garWHO_Best = garWHO
                grRMSEBEST = grRMSE
        write(6,*) 'garWIH_best=',garWIH_Best
        write(6,*) 'garWIO_best=',garWHO_Best
        ELSE
                garWIH = garWIH_Best
                garWHO = garWHO_Best
        ENDIF

END SUBROUTINE sKeep_Best_Weights





!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!  NON NEURAL SUBROUTINES AND FUNCTIONS !!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

SUBROUTINE sSetUp_1

        CALL Random_Seed
        CALL sSet_Data_Constants(giPATS,giINPUTS,iOUTPUTS,giNDU,giINPPB, &
             giFILEROWS,giDATAFIELDS)
        CALL sAllocate_Data_Arrays
        CALL sRead_Data(giUNITIN,giPATS,giNDU,garDataArray2)

END SUBROUTINE sSetUp_1

SUBROUTINE sSetUp_2

        CALL Random_Seed
        print *, 'Random_Seed'
        CALL sCreate_Training_Data
        print *, 'sCreate_Training_Data'
        CALL sScale_Data
        print *, 'sScale_Data'
        CALL sSet_Weight_Constants(giIOERR_OK)
        print *, 'sSet_Weight_Constants(giIOERR_OK)'
        CALL sAllocate_Weight_Arrays
        print *, 'sAllocate_Weight_Arrays'
        CALL sInitiate_Weights(garWIH,garWHO,garWIH_Best,garWHO_Best)
        print *, 'sInitiate_Weights'

END SUBROUTINE sSetUp_2

!------------------
! Display
!------------------
SUBROUTINE sDisplay_Headers
!print to the screen

        IF (giTESTPATS > 0) THEN
                PRINT *,'epochs   TRAIN_error   TEST_error'
        ELSE
                PRINT *,'epochs   TRAIN_error'
        ENDIF

END SUBROUTINE sDisplay_Headers



SUBROUTINE sDisplay_Errors

        REAL :: rAC, rSTDO, rSTDP       

      ! CALL sScale_Back()

        PRINT 100, frCalculate_Error &
        (garTrainingInputs,garTrainingOutputs, garWIH, garWHO)

        IF (giTESTPATS > 0) THEN 
                PRINT 110, frCalculate_Error &
                (garTestingInputs,garTestingOutputs,garWIH,garWHO)
        ENDIF

        IF (giVALIDPATS > 0) THEN
                PRINT 120, frCalculate_Error &
                (garValidationInputs,garValidationOutputs,garWIH,garWHO)
        ENDIF

100 FORMAT('TRAIN ERROR =',1X,F10.7)
110 FORMAT('TEST  ERROR =',1X,F10.7)
120 FORMAT('VAL   ERROR =',1X,F10.7)

        CALL sCalculate_AC(garTrainingInputs,garTrainingOutputs, &
        garWIH, garWHO, rAC, rSTDO, rSTDP, &
        giUNIT_TRAIN, gaWOUT_TRAIN, giTRAINPATS)

        PRINT 101, rAC, rSTDO, rSTDP

        IF (giTESTPATS > 0) THEN 

        CALL sCalculate_AC(garTestingInputs,garTestingOutputs, &
        garWIH, garWHO, rAC, rSTDO, rSTDP, &
        giUNIT_TEST, gaWOUT_TEST, giTESTPATS)

        PRINT 111, rAC, rSTDO, rSTDP

        ENDIF

        IF (giVALIDPATS > 0) THEN

        CALL sCalculate_AC(garValidationInputs,garValidationOutputs, &
        garWIH, garWHO, rAC, rSTDO, rSTDP, &
        giUNIT_VAL, gaWOUT_VAL, giVALIDPATS)

        PRINT 121, rAC, rSTDO, rSTDP

        ENDIF

101 FORMAT('TRAIN AC =',1X,F10.7,' STDO = ',1X,F10.7, &
' STDP = ',1X,F10.7)
111 FORMAT('TEST  AC =',1X,F10.7,' STDO = ',1X,F10.7, &
' STDP = ',1X,F10.7)
121 FORMAT('VAL AC =',1X,F10.7,' STDO = ',1X,F10.7, &
' STDP = ',1X,F10.7)

END SUBROUTINE sDisplay_Errors



SUBROUTINE sDisplay_Progress(iEpch)

        INTEGER, INTENT(IN) :: iEpch

        IF ( (MODULO(iEpch,giREDISPLAY)==0) .OR. (iEpch==giEPOCHS) .OR. &
(iEpch==1) ) THEN
                IF (giTESTPATS > 0) THEN
                        grRMSETEST = frCalculate_Error &
                        (garTestingInputs,garTestingOutputs,garWIH,garWHO)
                        PRINT 100,iEpch,grRMSEBEST,grRMSETEST
                ELSE
                        PRINT 110,iEpch,grRMSEBEST
                ENDIF
        ENDIF

100 FORMAT(I5,4X,F10.7,4X,F10.7)
110 FORMAT(I5,4X,F10.7)

END SUBROUTINE sDisplay_Progress



!--------------------------
! input file handling
!--------------------------

SUBROUTINE sRead_Data(iUNITNUMBER, iPATTERNS, iFIELDS, arDATAARRAY)

      INTEGER, INTENT(IN)  :: iUNITNUMBER     
      INTEGER, INTENT(IN)  :: iPATTERNS
      INTEGER, INTENT(IN)  :: iFIELDS
      INTEGER  :: I
      REAL :: fldin(iFIELDS)
      REAL :: arDATAARRAY(iPATTERNS,iFIELDS)

      CLOSE(iUNITNUMBER)

!! open for binary data file

      OPEN(UNIT=iUNITNUMBER, &
form='unformatted',access='direct',recl=4*iFIELDS)

      DO I = 1, iPATTERNS
        read (iUNITNUMBER, rec = I) fldin
        arDATAARRAY(I,1:iFIELDS) = fldin(1:iFIELDS)
      ENDDO

END SUBROUTINE sRead_Data

!--------------------------
! output file handling
!--------------------------

SUBROUTINE sWrite_Out(iUNITNUMBER, iPATTERNS, arDATAARRAY)

      INTEGER, INTENT(IN)  :: iUNITNUMBER     
      INTEGER, INTENT(IN)  :: iPATTERNS
      REAL,INTENT(IN) :: arDATAARRAY(iPATTERNS)

      CLOSE(iUNITNUMBER)

!! open for binary data file

      OPEN(UNIT=iUNITNUMBER, &
form='unformatted',access='direct',recl=4*iPATTERNS)

        write (iUNITNUMBER, rec = 1) arDATAARRAY

END SUBROUTINE sWrite_Out


!---------------------------
! getting user input
!---------------------------


!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!! DATA ALLOCATION SUBROUTINES AND FUNCTIONS   !!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

SUBROUTINE sAllocate_Data_Arrays()

        ! set the array dimensions
        ALLOCATE(garDataArray(giPATS,giNDU)) !rearranged raw data
        ALLOCATE(garDataArray2(giPATS,giNDU)) !raw data read from file
        ALLOCATE(garTrainingInputs(giTRAINPATS,giINPPB)) !input patterns
        ALLOCATE(garTrainingOutputs(giTRAINPATS)) !output
        ALLOCATE(garTestingInputs(giTESTPATS,giINPPB)) !input patterns
        ALLOCATE(garTestingOutputs(giTESTPATS)) !output
        ALLOCATE(garValidationInputs(giVALIDPATS,giINPPB)) !input patterns
        ALLOCATE(garValidationOutputs(giVALIDPATS)) !output
        ALLOCATE(garInputs_this_pattern(giINPPB)) !pattern being presented
        ALLOCATE(garMaxInp(giINPPB))
        ALLOCATE(garMinInp(giINPPB))

        ALLOCATE(gaWOUT_TRAIN(giTRAINPATS))
        ALLOCATE(gaWOUT_TEST(giTESTPATS))
        ALLOCATE(gaWOUT_VAL(giVALIDPATS))

END SUBROUTINE sAllocate_Data_Arrays



SUBROUTINE sAllocate_Weight_Arrays()

        ALLOCATE(garWIH(giINPPB,giNHS:giNHF))     !input-hidden weights
        ALLOCATE(garWIH_Best(giINPPB,giNHS:giNHF))!best weights 
        ALLOCATE(garWHO(giNHS:giNHF))             !hidden-output weights
        ALLOCATE(garWHO_Best(giNHS:giNHF))        !best weights
        ALLOCATE(garHVAL(giNHS:giNHF))            !hidden neuron outputs
        ALLOCATE(garDUMMY1(1,giNHS:giNHF))              !dummy matrix
        ALLOCATE(garDUMMY2(giINPPB,1))                  !dummy matrix

END SUBROUTINE sAllocate_Weight_Arrays

SUBROUTINE sDeAllocate_Weight_Arrays()

        DEALLOCATE(garWIH)     !input-hidden weights
        DEALLOCATE(garWIH_Best)!best weights 
        DEALLOCATE(garWHO)             !hidden-output weights
        DEALLOCATE(garWHO_Best)        !best weights
        DEALLOCATE(garHVAL)            !hidden neuron outputs
        DEALLOCATE(garDUMMY1)              !dummy matrix
        DEALLOCATE(garDUMMY2)                  !dummy matrix

END SUBROUTINE sDeAllocate_Weight_Arrays



SUBROUTINE sSet_Data_Constants &
        (iNPATS,iINPUTS,iNOUTPUTS,iNDU,iINPPB,iFILEROWS,iDATAFIELDS)

        INTEGER, INTENT (OUT)   :: iNPATS
        INTEGER, INTENT (OUT)   :: iINPUTS
        INTEGER, INTENT (OUT)   :: iNOUTPUTS
        INTEGER, INTENT (OUT)   :: iNDU
        INTEGER, INTENT (OUT)   :: iINPPB
        
        INTEGER, INTENT (IN)    :: iFILEROWS
        INTEGER, INTENT (IN)    :: iDATAFIELDS 


        iNPATS = iFILEROWS
        iINPUTS = iDATAFIELDS - 1
        iNOUTPUTS=1                     ! number of outputs (fixed)
        iNDU=iINPUTS+iNOUTPUTS          !Number Data Units
        iINPPB=iINPUTS+1                !INPut Plus Bias


END SUBROUTINE sSet_Data_Constants



SUBROUTINE sSet_Weight_Constants(iIOERR_OK)

        INTEGER, INTENT(IN) :: iIOERR_OK

        ! number the neurons
        giHIDDDEN=giHIDDDEN0+1          !accounts for bias to output
        giNHS=giINPPB+1                         !Number Hidden Start
        giNHF=giINPPB+giHIDDDEN                 !Number Hidden Finish
        giNOS=giNHF+1                           !Number Output Start

END SUBROUTINE sSet_Weight_Constants



SUBROUTINE sCreate_Training_Data()
! create train, test and validation sets

        INTEGER :: iTRAINCOUNT,iTESTCOUNT,iVALIDCOUNT
        INTEGER :: I
        REAL :: rTRPC,rTEPC
        REAL :: rRAND   
        
        rTRPC = FLOAT(giTRAINPATS) / FLOAT(giPATS)
        rTEPC = rTRPC + (FLOAT(giTESTPATS) / FLOAT(giPATS))
        
        iTRAINCOUNT = 0
        iTESTCOUNT = 0
        iVALIDCOUNT = 0

        PRINT *, ' Allocating data...'

 DO I=1,giPATS
        CALL RANDOM_NUMBER(rRAND)

        IF ((rRAND <= rTRPC) .AND. (iTRAINCOUNT < giTRAINPATS)) THEN
                iTRAINCOUNT = iTRAINCOUNT + 1 
                garTrainingInputs(iTRAINCOUNT,1:giINPUTS)=garDataArray(I,1:giINPUTS)
                garTrainingInputs(iTRAINCOUNT,giINPPB)=1
                garTrainingOutputs(iTRAINCOUNT)=garDataArray(I,giNDU)

        ELSEIF ((rRAND <= rTEPC) .AND. (iTESTCOUNT < giTESTPATS)) THEN
                iTESTCOUNT = iTESTCOUNT + 1
                garTestingInputs(iTESTCOUNT,1:giINPUTS)=garDataArray(I,1:giINPUTS)
                garTestingInputs(iTESTCOUNT,giINPPB)=1
                garTestingOutputs(iTESTCOUNT)=garDataArray(I,giNDU)

        ELSEIF ((rRAND > rTEPC) .AND. (iVALIDCOUNT < giVALIDPATS)) THEN
                iVALIDCOUNT = iVALIDCOUNT + 1
                garValidationInputs(iVALIDCOUNT,1:giINPUTS)=garDataArray(I,1:giINPUTS)
                garValidationInputs(iVALIDCOUNT,giINPPB)=1
                garValidationOutputs(iVALIDCOUNT)=garDataArray(I,giNDU)

        ELSEIF (iTRAINCOUNT < giTRAINPATS) THEN
                iTRAINCOUNT = iTRAINCOUNT + 1 
                garTrainingInputs(iTRAINCOUNT,1:giINPUTS)=garDataArray(I,1:giINPUTS)
                garTrainingInputs(iTRAINCOUNT,giINPPB)=1
                garTrainingOutputs(iTRAINCOUNT)=garDataArray(I,giNDU)

        ELSEIF (iTESTCOUNT < giTESTPATS) THEN
                iTESTCOUNT = iTESTCOUNT + 1
                garTestingInputs(iTESTCOUNT,1:giINPUTS)=garDataArray(I,1:giINPUTS)
                garTestingInputs(iTESTCOUNT,giINPPB)=1
                garTestingOutputs(iTESTCOUNT)=garDataArray(I,giNDU)

        ELSEIF (iVALIDCOUNT < giVALIDPATS) THEN
                iVALIDCOUNT = iVALIDCOUNT + 1
                garValidationInputs(iVALIDCOUNT,1:giINPUTS)=garDataArray(I,1:giINPUTS)
                garValidationInputs(iVALIDCOUNT,giINPPB)=1
                garValidationOutputs(iVALIDCOUNT)=garDataArray(I,giNDU)

        ENDIF

 ENDDO

        !the array 'data' is no longer required
!       DEALLOCATE(garDataArray)                                
        PRINT *, ' Data allocated OK!'

END SUBROUTINE sCreate_Training_Data




SUBROUTINE sScale_Data()
! scale the data

        INTEGER :: I

        PRINT *, ' Normalising data...'

        ! find the max and min values
        garMaxInp(:) = MAXVAL(garTrainingInputs,1)
        garMinInp(:) = MINVAL(garTrainingInputs,1)
        grMaxOut = MAXVAL(garTrainingOutputs)
        grMinOut = MINVAL(garTrainingOutputs)


        ! need to check if max = min

        ! scale between -1 and 1
        DO i = 1,giTRAINPATS
        garTrainingInputs(i,1:giINPUTS) = &
        ((garTrainingInputs(i,1:giINPUTS) - garMinInp(1:giINPUTS)) / &
        (garMaxInp(1:giINPUTS) - garMinInp(1:giINPUTS)) - 0.5) * 2
        ENDDO   

        garTrainingOutputs(:) = &
        ((garTrainingOutputs(:) - grMinOut) / (grMaxOut - grMinOut) - &
0.5) * 2
        
        IF (giTESTPATS > 0) THEN
        DO i = 1,giTESTPATS
        garTestingInputs(i,1:giINPUTS) = &
        ((garTestingInputs(i,1:giINPUTS) - garMinInp(1:giINPUTS)) / &
        (garMaxInp(1:giINPUTS) - garMinInp(1:giINPUTS)) - 0.5) * 2
        ENDDO           
        garTestingOutputs(:) = &
        ((garTestingOutputs(:) - grMinOut) / (grMaxOut - grMinOut) - &
0.5) * 2
        ENDIF

        IF (giVALIDPATS > 0) THEN
        DO i = 1,giVALIDPATS
        garValidationInputs(i,1:giINPUTS) = &
        ((garValidationInputs(i,1:giINPUTS) - garMinInp(1:giINPUTS)) / &
        (garMaxInp(1:giINPUTS) - garMinInp(1:giINPUTS)) - 0.5) * 2
        ENDDO   
        garValidationOutputs(:) = &
        ((garValidationOutputs(:) - grMinOut) / (grMaxOut - grMinOut) - &
0.5) * 2
        ENDIF

        PRINT *, ' Data normalised OK!'
        PRINT *, ''

END SUBROUTINE sScale_Data


SUBROUTINE sScale_Back()

! scale back the input predictor and predictand data

        INTEGER :: I

        PRINT *, ' Scale back data begin...'

        ! scale back from [-1,+1]
        DO I = 1,giTRAINPATS
        garTrainingInputs(i,1:giINPUTS) = &
        0.5 * (1 + garTrainingInputs(i,1:giINPUTS)) * &
        (garMaxInp(1:giINPUTS) - garMinInp(1:giINPUTS)) + &
        garMinInp(1:giINPUTS)
        ENDDO   

        garTrainingOutputs(:) = &
        0.5 * (1 + garTrainingOutputs(:)) * &
        (grMaxOut - grMinOut) + grMinOut
        
        IF (giTESTPATS > 0) THEN
        DO I = 1,giTESTPATS
        garTestingInputs(i,1:giINPUTS) = &
        0.5 * (1 + garTestingInputs(i,1:giINPUTS)) * &
        (garMaxInp(1:giINPUTS) - garMinInp(1:giINPUTS)) + &
        garMinInp(1:giINPUTS)
        ENDDO           
        garTestingOutputs(:) = &
        0.5 * (1 + garTestingOutputs(:)) * & 
        (grMaxOut - grMinOut) + grMinOut
        ENDIF

        IF (giVALIDPATS > 0) THEN
        DO I = 1,giVALIDPATS
        garValidationInputs(i,1:giINPUTS) = &
        0.5 * (1 + garValidationInputs(i,1:giINPUTS)) * &
        (garMaxInp(1:giINPUTS) - garMinInp(1:giINPUTS)) + &
        garMinInp(1:giINPUTS)
        ENDDO   
        garValidationOutputs(:) = &
        0.5 * (1 + garValidationOutputs(:)) * &
        (grMaxOut - grMinOut) + grMinOut
        ENDIF

        PRINT *, ' Data scaled back!'
        PRINT *, ''

END SUBROUTINE sScale_Back


SUBROUTINE sScale_Prd(NT,PRD)

! scale prd to the predictand in training period

        INTEGER :: NT
        REAL :: PRD(NT)
        INTEGER :: I

     !  PRINT *, ' Scale back prd data begin...'

        ! scale back from [-1,+1]

        PRD(:) = &
        0.5 * (1 + PRD(:)) * (grMaxOut - grMinOut) + grMinOut

END SUBROUTINE sScale_Prd



SUBROUTINE sInitiate_Weights(arWIHL,arWHOL,arWIHBESTL,arWHOBESTL)
! generate initial random weights
        
        Real, Dimension (:,:),  Intent (INOUT) :: arWIHL
        Real, Dimension (:,:),  Intent (INOUT) :: arWIHBESTL    
        Real, Dimension (:),    Intent (INOUT) :: arWHOL
        Real, Dimension (:),    Intent (INOUT) :: arWHOBESTL    

        INTEGER :: J, K
        REAL :: rRAND

        DO K=LBOUND(arWIHL,2),UBOUND(arWIHL,2)
                CALL RANDOM_NUMBER(rRAND)
                arWHOL(K)=((rRAND-0.5)*2)/10
                DO J=LBOUND(arWIHL,1),UBOUND(arWIHL,1)
                        CALL RANDOM_NUMBER(rRAND)
                        arWIHL(J,K)=((rRAND-0.5)*2)/10
                ENDDO
        ENDDO

        arWIHBESTL=arWIHL !record of best weights so far
        arWHOBESTL=arWHOL !record of best weights so far

END SUBROUTINE sInitiate_Weights


END PROGRAM Neural_Simulator


