#!/bin/bash

# Make sure we are in the correct directory where packages are installed
# In Vercel, this is /vercel/path0/.py/lib/pythonX.X/site-packages/

cd "$(python -c 'import site; print(site.getsitepackages()[0])')"

echo "Current directory: $(pwd)"
echo "Slimming down numpy and pandas..."

# 1. Remove all test directories, which are large and not needed for execution.
find . -type d -name "tests" -exec rm -r {} +

# 2. Strip debug symbols from the compiled .so files. This is a huge space saver.
# The -S and -x flags are for more aggressive stripping.
find . -name "*.so" -type f -exec strip -S -x {} +

# 3. Remove C/C++ header files (.h) which are only needed for compiling against the library.
find . -name "*.h" -type f -exec rm -f {} +

# 4. Remove numpy's C header files specifically
if [ -d "numpy/core/include" ]; then
    echo "Removing numpy/core/include..."
    rm -rf numpy/core/include
fi

# 5. Remove dist-info directories for the big libraries. This saves a surprising amount of space.
# These contain metadata for pip, which is not needed at runtime.
rm -rf numpy-*.dist-info
rm -rf pandas-*.dist-info

echo "Cleanup complete. Final size of site-packages:"
du -sh .