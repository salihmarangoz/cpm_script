CPM_ROOT="$HOME/cpm"
SYMLINK_ROOT="$CPM_ROOT/root"
SYMLINK_PARAM="-ans" # overwrite symlinks: -as , don't overwrite symlinks -ans
CMAKE_JOBS=4
CMAKE_BUILD_TYPE="Release"
CMAKE_C_FLAGS="-march=native -mtune=native"
CMAKE_CXX_FLAGS="-march=native -mtune=native"

export LD_LIBRARY_PATH="$CPM_ROOT/root/lib:$LD_LIBRARY_PATH"
export CMAKE_PREFIX_PATH="$CPM_ROOT/root:$CMAKE_PREFIX_PATH"
export PATH="$CPM_ROOT/root/bin:$PATH"

function cpm_make(){
    set -e
    cpm_current_dir=${PWD##*/}                   # get current dir
    cpm_current_dir=$(echo "${cpm_current_dir// /}") # remove whitespaces
    cpm_root_dir="$CPM_ROOT/root"
    cpm_pkg_dir="$CPM_ROOT/pkgs/$cpm_current_dir"
    mkdir -p "$cpm_root_dir"
    mkdir -p "$cpm_pkg_dir"

    # build package
    mkdir -p build
    cd build
    cmake .. -DCMAKE_INSTALL_PREFIX="$cpm_pkg_dir" -DCMAKE_BUILD_TYPE="$CMAKE_BUILD_TYPE" -DCMAKE_C_FLAGS="$CMAKE_C_FLAGS" -DCMAKE_CXX_FLAGS="$CMAKE_CXX_FLAGS"
    make -j "$CMAKE_JOBS"
    cd ..
}

function cpm_install(){
    set -e
    cpm_current_dir=${PWD##*/}                   # get current dir
    cpm_current_dir=$(echo "${cpm_current_dir// /}") # remove whitespaces
    cpm_root_dir="$CPM_ROOT/root"
    cpm_pkg_dir="$CPM_ROOT/pkgs/$cpm_current_dir"
    mkdir -p "$cpm_root_dir"
    mkdir -p "$cpm_pkg_dir"

    cd build
    make -j "$CMAKE_JOBS" install
    cd ..
    cp "$SYMLINK_PARAM" "$cpm_pkg_dir/"* "$cpm_root_dir/"
}

function cpm_make_install(){
    set -e
    cpm_make
    cpm_install
}

function cpm_manager(){
    # todo:
    #find "$cpm_root_dir" -xtype l -delete
}