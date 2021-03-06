#ifndef SAFETY_FILTER_NODE_H
#define SAFETY_FILTER_NODE_H

#include "ros/ros.h"
#include "uav_sim_ros/cmd.h"
#include "uav_sim_ros/input.h"
#include "uav_sim_ros/state.h"
#include "uav_sim_ros/filterInfo.h"
#include "std_msgs/String.h"
#include "sensor_msgs/PointCloud2.h"
#include "geometry_msgs/PoseStamped.h"
#include "visualization_msgs/Marker.h"
#include "nav_msgs/Path.h"
#include "uav_sim_ros/common.hpp"

#include <boost/numeric/odeint.hpp>
#include <boost/numeric/odeint/iterator/n_step_iterator.hpp>

#ifdef CODEGEN
#include <Eigen/Dense>
#include "UAVDynamics.h"
using namespace Eigen;
#else
#include "uav_sim_ros/uav_dynamics_alt.hpp"
#endif

using namespace boost::numeric::odeint;
typedef std::vector<double>   state_t;
// typedef euler<state_t>        stepper_t;
typedef runge_kutta4<state_t> stepper_t;

enum class STATUS : uint8_t
{
	FAILURE = 0,
	RUNNING = 1
};

const uint32_t nx_ = STATE_LENGTH;
const uint32_t nu_ = INPUT_LENGTH;
const uint32_t npSS_ = 4;
const uint32_t npBS_ = 1;
const uint32_t npBTSS_ = 4;

const double lb_[nu_] = {-1.0,-1.0,-1.0,-1.0};
const double ub_[nu_] = { 1.0, 1.0, 1.0, 1.0};

#endif
