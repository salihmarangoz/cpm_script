CPM_PATH="/cpm"
CPM_CURRENT_ROOT="$CPM_PATH/root"
SYMLINK_PARAM="-ans" # overwrite symlinks: -as , don't overwrite symlinks -ans
CMAKE_JOBS=4
CMAKE_BUILD_TYPE="Release"
CMAKE_C_FLAGS="-march=native -mtune=native"
CMAKE_CXX_FLAGS="-march=native -mtune=native"

export LD_LIBRARY_PATH="$CPM_CURRENT_ROOT/lib:$LD_LIBRARY_PATH"       # For loading libraries
export CMAKE_PREFIX_PATH="$CPM_CURRENT_ROOT:$CMAKE_PREFIX_PATH"       # For finding libraries with cmake
export PATH="$CPM_CURRENT_ROOT/bin:$PATH"                             # For adding binaries for easy access


function cpm_make_install(){
    pwd_dir=${PWD##*/}                    # get current dir
    pwd_dir=$(echo "${pwd_dir// /}")      # remove whitespaces
    cpm_pkg_dir="$CPM_PATH/pkgs/$pwd_dir"
    mkdir -p "$CPM_CURRENT_ROOT"
    mkdir -p "$cpm_pkg_dir"

    # build package
    mkdir -p build
    cd build
    cmake .. -DCMAKE_INSTALL_PREFIX="$cpm_pkg_dir" -DCMAKE_BUILD_TYPE="$CMAKE_BUILD_TYPE" -DCMAKE_C_FLAGS="$CMAKE_C_FLAGS" -DCMAKE_CXX_FLAGS="$CMAKE_CXX_FLAGS" &&
    make -j "$CMAKE_JOBS" install &&
    cd .. &&
    cp "$SYMLINK_PARAM" "$cpm_pkg_dir/"* "$CPM_CURRENT_ROOT/" # todo add check
}


function cpm_refresh(){
    echo "Purging $CPM_CURRENT_ROOT"
    rm -rf "$CPM_CURRENT_ROOT"
    mkdir -p "$CPM_CURRENT_ROOT"

    for cpm_pkg_dir in "$CPM_PATH/pkgs"/*; do
        echo "Linking $cpm_pkg_dir"
        cp "$SYMLINK_PARAM" "$cpm_pkg_dir/"* "$CPM_CURRENT_ROOT/"
    done

    echo "Done!"
}

function cpm_get_params(){
    echo ""
    echo "===== CPM PARAMS ====="
    echo "CPM_PATH = $CPM_PATH"
    echo "CPM_CURRENT_ROOT = $CPM_CURRENT_ROOT"
    echo "SYMLINK_PARAM = $SYMLINK_PARAM"
    echo "CMAKE_JOBS = $CMAKE_JOBS"
    echo "CMAKE_BUILD_TYPE = $CMAKE_BUILD_TYPE"
    echo "CMAKE_C_FLAGS = $CMAKE_C_FLAGS"
    echo "CMAKE_CXX_FLAGS = $CMAKE_CXX_FLAGS"
    echo ""
    echo "===== ENV AFFECTED BY CPM ====="
    echo "LD_LIBRARY_PATH = $LD_LIBRARY_PATH"
    echo "LD_LIBRARY_PATH = $LD_LIBRARY_PATH"
    echo "PATH = $PATH"
    echo ""
}

function cpm_list_packages(){
    du -h -d 1  "$CPM_PATH/pkgs" | head -n -1
}