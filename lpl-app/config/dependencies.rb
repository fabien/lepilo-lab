# dependencies are generated using a strict version, don"t forget to edit the dependency versions when upgrading.
merb_gems_version = "1.0.9"

# For more information about each component, please read http://wiki.merbivore.com/faqs/merb_components
dependency "merb-action-args", merb_gems_version
dependency "merb-assets", merb_gems_version  
dependency "merb-cache", merb_gems_version
dependency "merb-helpers", merb_gems_version 
dependency "merb-mailer", merb_gems_version
dependency "merb-slices", merb_gems_version
dependency "merb-param-protection", merb_gems_version
dependency "merb-exceptions", merb_gems_version

# Load LplCore and LplCore extension slices.
lpl_gems_version = "0.0.1"

dependency "lpl-core", lpl_gems_version
dependency "sofa-pages"
dependency "graphics-slice"