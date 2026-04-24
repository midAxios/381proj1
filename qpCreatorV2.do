# ============================================================
# Auto-create Questa/ModelSim project and import VHDL files
# Run this script from inside the proj/ folder.
# Expected structure:
#   proj/
#     qpCreator.do
#     src/
#       *.vhd
# ============================================================

# Change this if needed
set PROJECT_NAME "proj1"

# Since this .do file is run from inside proj/, source files are in ./src
set SRC_ROOT [file normalize "./src"]

# Questa project will be created inside proj/questa_project
set PROJECT_DIR [file normalize "./questa_project"]

# ------------------------------------------------------------
# Sanity checks
# ------------------------------------------------------------
if {![file isdirectory $SRC_ROOT]} {
    puts ""
    puts "ERROR: Could not find src folder."
    puts "This script must be run from inside your proj folder."
    puts "Expected source path: $SRC_ROOT"
    puts ""
    error "Missing src folder"
}

# Count .vhd files recursively under ./src
proc count_vhd_files {dir} {
    set count 0

    foreach item [glob -nocomplain -directory $dir *] {
        if {[file isdirectory $item]} {
            incr count [count_vhd_files $item]
        } else {
            set ext [string tolower [file extension $item]]
            if {$ext eq ".vhd"} {
                incr count
            }
        }
    }

    return $count
}

set VHD_COUNT [count_vhd_files $SRC_ROOT]

if {$VHD_COUNT == 0} {
    puts ""
    puts "ERROR: No .vhd files found inside src/."
    puts "Checked source path: $SRC_ROOT"
    puts "Make sure your VHDL files are in proj/src/ before running this script."
    puts ""
    error "No VHDL source files found"
}

puts "Found $VHD_COUNT .vhd file(s) under: $SRC_ROOT"

# ------------------------------------------------------------
# Create/open project
# ------------------------------------------------------------
file mkdir $PROJECT_DIR

set PROJECT_FILE [file join $PROJECT_DIR "$PROJECT_NAME.mpf"]

if {[file exists $PROJECT_FILE]} {
    puts "Opening existing project: $PROJECT_FILE"
    project open $PROJECT_FILE
} else {
    puts "Creating new project: $PROJECT_NAME"
    project new $PROJECT_DIR $PROJECT_NAME
}

# Folders to ignore while walking ./src recursively
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

# Only import VHDL source files for this class project
set HDL_EXTENSIONS {
    .vhd
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
puts "Done importing VHDL files."
puts "Project created/opened at: $PROJECT_FILE"
puts "Imported from source folder: $SRC_ROOT"
puts ""
