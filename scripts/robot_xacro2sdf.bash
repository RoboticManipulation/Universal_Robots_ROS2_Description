#!/usr/bin/env bash
# This script converts xacro (URDF variant) into SDF for `ur_2f_85_description` package

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
XACRO_PATH="$(dirname "${SCRIPT_DIR}")/urdf/ur.urdf.xacro"
SDF_PATH="$(dirname "${SCRIPT_DIR}")/urdf/robot_generated.sdf"
TMP_URDF_PATH="$(dirname "${SCRIPT_DIR}")/temp/robot_tmp.urdf"

# Arguments for xacro
XACRO_ARGS=(
    robot_ip:=yyy.yyy.yyy.yyy
    joint_limit_params:=$(dirname "${SCRIPT_DIR}")/config/ur5/joint_limits.yaml
    kinematics_params:=$(dirname "${SCRIPT_DIR}")/config/ur5/default_kinematics.yaml
    physical_params:=$(dirname "${SCRIPT_DIR}")/config/ur5/physical_parameters.yaml
    visual_params:=$(dirname "${SCRIPT_DIR}")/config/ur5/visual_parameters.yaml
    safety_limits:=true
    safety_pos_margin:=0.15
    safety_k_position:=20
    name:=ur
    ur_type:=ur5
    script_filename:=ros_control.urscript
    input_recipe_filename:=rtde_input_recipe.txt
    output_recipe_filename:=rtde_output_recipe.txt
    tf_prefix:=""
    sim_ignition:=true
    simulation_controllers:=/home/bk/ros2/object_placement/object_placement_ws/src/ur_2f_85_moveit2/ur_2f_85_moveit2_config/config/ur_controllers.yaml
)

# Remove old SDF file
rm "${SDF_PATH}" 2>/dev/null

# Process xacro into URDF, then convert URDF to SDF and edit the SDF to use relative paths for meshes
xacro "${XACRO_PATH}" "${XACRO_ARGS[@]}" -o "${TMP_URDF_PATH}" &&
#ign sdf -p "${TMP_URDF_PATH}" | sed "s/model:\/\/ur_2f_85_description\///g" >"${SDF_PATH}" &&
ign sdf -p "${TMP_URDF_PATH}" >"${SDF_PATH}" &&
echo "Created new ${SDF_PATH}"

# Remove temporary URDF file
rm "${TMP_URDF_PATH}" 2>/dev/null

# Add to stating area
#git add "${SDF_PATH}"
