rp_module_id="lr-picodrive"
rp_module_desc="Sega 8/16 bit emu - picodrive arm optimised libretro core"
rp_module_menus="2+"

function sources_lr-picodrive() {
    gitPullOrClone "$md_build" https://github.com/libretro/picodrive.git
    git submodule init
    git submodule update
}

function build_lr-picodrive() {
    make clean
    make -f Makefile.libretro platform=armv6
    md_ret_require="$md_build/picodrive_libretro.so"
}

function install_lr-picodrive() {
    md_ret_files=(
        'AUTHORS'
        'COPYING'
        'picodrive_libretro.so'
        'README'
    )
}

function configure_lr-picodrive() {
    # remove old install folder
    rm -rf "$rootdir/$md_type/picodrive"

    mkRomDir "megadrive"
    mkRomDir "mastersystem"
    mkRomDir "segacd"
    mkRomDir "sega32x"
    ensureSystemretroconfig "megadrive"
    ensureSystemretroconfig "mastersystem"
    ensureSystemretroconfig "segacd"
    ensureSystemretroconfig "sega32x"

    # system-specific shaders, Megadrive
    iniConfig " = " "" "$configdir/megadrive/retroarch.cfg"
    iniSet "video_shader" "$emudir/retroarch/shader/phosphor.glslp"
    iniSet "video_shader_enable" "false"
    iniSet "video_smooth" "false"
    iniSet "input_remapping_directory" "$configdir/megadrive/"

    # system-specific shaders, Mastersystem
    iniConfig " = " "" "$configdir/mastersystem/retroarch.cfg"
    iniSet "video_shader" "$emudir/retroarch/shader/phosphor.glslp"
    iniSet "video_shader_enable" "false"
    iniSet "video_smooth" "false"
    iniSet "input_remapping_directory" "$configdir/mastersystem/"

    # system-specific shaders, Megadrive
    iniConfig " = " "" "$configdir/segacd/retroarch.cfg"
    iniSet "input_remapping_directory" "$configdir/segacd/"

    # system-specific shaders, Megadrive
    iniConfig " = " "" "$configdir/sega32x/retroarch.cfg"
    iniSet "input_remapping_directory" "$configdir/sega32x/"

    setESSystem "Sega Master System / Mark III" "mastersystem" "~/RetroPie/roms/mastersystem" ".sms .SMS .zip .ZIP" "$rootdir/supplementary/runcommand/runcommand.sh 4 \"$emudir/retroarch/bin/retroarch -L $md_inst/picodrive_libretro.so --config $configdir/all/retroarch.cfg --appendconfig $configdir/mastersystem/retroarch.cfg %ROM%\" \"$md_id\"" "mastersystem" "mastersystem"

    setESSystem "Sega Mega Drive / Genesis" "megadrive" "~/RetroPie/roms/megadrive" ".smd .SMD .bin .BIN .gen .GEN .md .MD .zip .ZIP" "$rootdir/supplementary/runcommand/runcommand.sh 4 \"$emudir/retroarch/bin/retroarch -L $md_inst/picodrive_libretro.so --config $configdir/all/retroarch.cfg --appendconfig $configdir/megadrive/retroarch.cfg %ROM%\" \"$md_id\"" "genesis,megadrive" "megadrive"

    setESSystem "Sega CD" "segacd" "~/RetroPie/roms/segacd" ".smd .SMD .bin .BIN .md .MD .zip .ZIP .iso .ISO .zip .ZIP" "$rootdir/supplementary/runcommand/runcommand.sh 1 \"$emudir/retroarch/bin/retroarch -L $md_inst/picodrive_libretro.so --config $configdir/all/retroarch.cfg --appendconfig $configdir/segacd/retroarch.cfg %ROM%\" \"$md_id\"" "segacd" "segacd"

    setESSystem "Sega 32X" "sega32x" "~/RetroPie/roms/sega32x" ".32x .32X .smd .SMD .bin .BIN .md .MD .zip .ZIP" "$rootdir/supplementary/runcommand/runcommand.sh 1 \"$emudir/retroarch/bin/retroarch -L $md_inst/picodrive_libretro.so --config $configdir/all/retroarch.cfg --appendconfig $configdir/sega32x/retroarch.cfg %ROM%\" \"$md_id\"" "sega32x" "sega32x"
}
