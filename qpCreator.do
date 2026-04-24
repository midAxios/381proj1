# ============================================================
# Auto-create Questa/ModelSim project and import HDL files
# ============================================================

# Change these two lines if needed
set PROJECT_NAME "381proj1"
set SRC_ROOT [file normalize "./381proj1"]

# This is where the Questa project file will be created
set PROJECT_DIR [file normalize "./questa_project"]

file mkdir $PROJECT_DIR

# Create or open project
set PROJECT_FILE [file join $PROJECT_DIR "$PROJECT_NAME.mpf"]

if {[file exists $PROJECT_FILE]} {
    puts "Opening existing project: $PROJECT_FILE"
    project open $PROJECT_FILE
} else {
    puts "Creating new project: $PROJECT_NAME"
    project new $PROJECT_DIR $PROJECT_NAME
}

# Folders to ignore
set SKIP_DIRS {
    work
    questa_project
    simulation
    incremental_db
    output_files
    db
    .git
    __pycache__
}

# File extensions to import
set HDL_EXTENSIONS {
    .vhd
    .vhdl
    .v
    .sv
}

proc add_hdl_files {dir skip_dirs hdl_extensions} {
    foreach item [glob -nocomplain -directory $dir *] {
        if {[file isdirectory $item]} {
            set folder_name [file tail $item]

            if {[lsearch -exact $skip_dirs $folder_name] >= 0} {
                puts "Skipping folder: $item"
            } else {
                add_hdl_files $item $skip_dirs $hdl_extensions
            }

        } else {
            set ext [string tolower [file extension $item]]

            if {[lsearch -exact $hdl_extensions $ext] >= 0} {
                puts "Adding file: $item"
                project addfile $item
            }
        }
    }
}

add_hdl_files $SRC_ROOT $SKIP_DIRS $HDL_EXTENSIONS

puts ""
puts "Done importing HDL files."
puts "Project created/opened at: $PROJECT_FILE"
puts ""
