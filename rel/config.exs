use Mix.Releases.Config,
    # This sets the default release built by `mix release`
    default_release: :default,
    # This sets the default environment used by `mix release`
    default_environment: :dev

# For a full list of config options for both releases
# and environments, visit https://hexdocs.pm/distillery/configuration.html


# You may define one or more environments in this file,
# an environment's settings will override those of a release
# when building in that environment, this combination of release
# and environment configuration is called a profile

environment :dev do
  set dev_mode: true
  set include_erts: false
  set cookie: :"*W.c~*x$@%D4YA?C0q%rJXx*FTX467>On^]pI=E!g/2;G)K2.&X61vNlNa%Ofn(%"
end

environment :prod do
  set include_erts: true
  set include_src: false
  set cookie: :"Pzswc.qI=)rog(kCeewz=`qtSFpc<QsJhXL?Z2BVm)aP%i$ctr^r]gJY6?Ry(iOK"
end

# You may define one or more releases in this file.
# If you have not set a default release, or selected one
# when running `mix release`, the first release in the file
# will be used by default

release :phoeneat do
  set version: current_version(:phoeneat)
end

