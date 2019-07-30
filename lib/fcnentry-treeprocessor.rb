RUBY_ENGINE == 'opal' ? (require 'fcnentry-treeprocessor/extension') : (require_relative 'fcnentry-treeprocessor/extension')
 
Extensions.register do
  treeprocessor FcnEntryTreeProcessor
  docinfo_processor FcnEntryDocinfoProcessor
end
