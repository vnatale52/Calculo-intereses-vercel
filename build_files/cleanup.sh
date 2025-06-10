#!/bin/bash

echo "--- Starting Aggressive Cleanup ---"

# Go to the site-packages directory
cd "$(python -c 'import site; print(site.getsitepackages()[0])')"

echo "Initial size of site-packages:"
du -sh .

# 1. Remove all test directories
echo "Deleting test directories..."
find . -type d -name "tests" -exec rm -r {} +

# 2. Remove all __pycache__ directories
echo "Deleting __pycache__ directories..."
find . -type d -name "__pycache__" -exec rm -r {} +

# 3. Strip all .so files (this is the most important step)
echo "Stripping .so files..."
find . -name "*.so" -type f -exec strip -S -x {} +

# 4. Remove .pyc files
echo "Deleting .pyc files..."
find . -name "*.pyc" -exec rm -f {} +

# 5. Remove all metadata directories (more aggressive)
echo "Deleting .dist-info and .egg-info directories..."
rm -rf *-*.dist-info
rm -rf *-*.egg-info

# 6. Remove header files
echo "Deleting header files..."
find . -name "*.h" -type f -exec rm -f {} +
if [ -d "numpy/core/include" ]; then rm -rf numpy/core/include; fi

echo "Final size of site-packages:"
du -sh .
echo "--- Cleanup Complete ---"
