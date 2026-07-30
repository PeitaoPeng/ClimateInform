// ---------------------------------------------------------
// Back-to-Top Button Logic
// ---------------------------------------------------------

const backToTopBtn = document.getElementById('back-to-top');

window.addEventListener('scroll', () => {
    const scrollTop = document.documentElement.scrollTop || document.body.scrollTop;

    // Show/hide Back-to-Top button
    if (scrollTop > 300) {
        backToTopBtn.classList.add('visible');
    } else {
        backToTopBtn.classList.remove('visible');
    }

    // Update scroll progress bar
    const scrollHeight = document.documentElement.scrollHeight - document.documentElement.clientHeight;
    const scrolledPercent = (scrollTop / scrollHeight) * 100;
    document.getElementById('scroll-progress').style.width = scrolledPercent + '%';
});

// Smooth scroll to top
backToTopBtn.addEventListener('click', () => {
    window.scrollTo({ top: 0, behavior: 'smooth' });
});

