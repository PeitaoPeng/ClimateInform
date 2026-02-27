#!/bin/sh
# Use the POSIX shell interpreter for maximum portability.

set -e
# Exit immediately if any command fails. Prevents partial directory creation.

# Base directory for your website repo
WEBDIR="website"
# This variable defines the root folder where the entire site structure will be created.

echo "Creating ClimateInform website structure under: $WEBDIR"
# Inform the user what directory is being created.

# -----------------------------
# Core top-level HTML pages
# -----------------------------
mkdir -p $WEBDIR
# Create the main website directory if it doesn't already exist.

touch $WEBDIR/index.html
# Homepage of the website.

touch $WEBDIR/forecasts.html
# Landing page for forecast products.

touch $WEBDIR/methodology.html
# Page explaining scientific methods and modeling.

touch $WEBDIR/about.html
# About ClimateInform, mission, background.

touch $WEBDIR/contact.html
# Contact information page.

# -----------------------------
# CSS and JavaScript directories
# -----------------------------
mkdir -p $WEBDIR/css
# Folder for all CSS stylesheets.

touch $WEBDIR/css/style.css
# Main stylesheet for the site.

touch $WEBDIR/css/theme.css
# Optional theme or layout-specific styles.

mkdir -p $WEBDIR/js
# Folder for JavaScript files.

touch $WEBDIR/js/main.js
# Main JavaScript file for site-wide behavior.

touch $WEBDIR/js/menu.js
# Script for navigation menu interactions.

# -----------------------------
# Assets (images, icons, logos)
# -----------------------------
mkdir -p $WEBDIR/assets
# Folder for static assets like logos, icons, banners.

touch $WEBDIR/assets/.keep
# Placeholder file so Git tracks the empty directory.

# -----------------------------
# Components (shared HTML parts)
# -----------------------------
mkdir -p $WEBDIR/components
# Folder for reusable HTML fragments.

touch $WEBDIR/components/header.html
# Shared header (logo, navigation bar).

touch $WEBDIR/components/footer.html
# Shared footer (copyright, links).

touch $WEBDIR/components/sidebar.html
# Optional sidebar for navigation or metadata.

# -----------------------------
# Subpages and content sections
# -----------------------------
mkdir -p $WEBDIR/pages/forecasts
# Folder for forecast subpages (yearly/monthly).

mkdir -p $WEBDIR/pages/methodology
# Folder for detailed scientific documentation.

mkdir -p $WEBDIR/pages/docs
# Folder for API docs, technical notes, or future expansion.

# -----------------------------
# Example forecast pages
# -----------------------------
touch $WEBDIR/pages/forecasts/2025.html
# Year-level summary page for 2025 forecasts.

touch $WEBDIR/pages/forecasts/2025-01.html
touch $WEBDIR/pages/forecasts/2025-02.html
touch $WEBDIR/pages/forecasts/2025-03.html
# Monthly forecast pages for January–March 2025.

# -----------------------------
# GitHub Pages configuration
# -----------------------------
touch $WEBDIR/_config.yml
# Optional Jekyll config file for GitHub Pages (even if empty).

echo "Website structure created successfully."
# Final confirmation message.
