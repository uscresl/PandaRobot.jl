__precompile__()

module PandaRobot

using RigidBodyDynamics
using StaticArrays

export Panda,
  packagepath,
  urdfpath

packagepath() = joinpath(@__DIR__, "..", "deps")
urdfpath() = joinpath(packagepath(), "Panda", "panda.urdf")

mutable struct Panda{T}
  mechanism::Mechanism{T}

  function Panda{T}() where T 
    mechanism = RigidBodyDynamics.parse_urdf(T,urdfpath())
    new{T}(mechanism) 
  end
end
Panda(::Type{T} = Float64; kwargs...) where {T} = Panda{T}(; kwargs...)

function __init__()
  if !isfile(urdfpath())
    error("Could not find $(urdfpath()). Please run `import Pkg; Pkg.build(\"Panda\")`.")
  end
  
  # Setup ros environment to help MeshCatMechanism.jl to resolve "package://..." in the urdf file
  PandaRobotDepsPath = string(dirname(pathof(PandaRobot)), "/../deps/")
  ENV["ROS_PACKAGE_PATH"] = string(get(ENV, "ROS_PACKAGE_PATH", ""), ":", PandaRobotDepsPath)
end

end # module
