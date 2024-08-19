#!/usr/bin/env bash
# This script converts xacro (URDF variant) into URDF for `ur_2f_85_description` package

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
XACRO_PATH="$(dirname "${SCRIPT_DIR}")/urdf/ur.urdf.xacro"
URDF_PATH="$(dirname "${SCRIPT_DIR}")/urdf/robot_generated.urdf"

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
    sim_ignition:=false
    simulation_controllers:=/home/bk/ros2/object_placement/ur_driver_ws/src/Universal_Robots_ROS2_Driver/ur_bringup/config/ur_controllers.yaml
)

# Remove old URDF file
rm "${URDF_PATH}" 2>/dev/null

# Process xacro into URDF
xacro "${XACRO_PATH}" "${XACRO_ARGS[@]}" -o "${URDF_PATH}" &&
echo "Created new ${URDF_PATH}"

# Add to stating area
#git add "${URDF_PATH}"
