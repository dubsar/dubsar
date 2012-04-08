class Inheritance < ActiveRecord::Base
  set_primary_key :id
  has_ancestry
  def self.entities
    self.roots.find_by_name("entities").subtree.arrange
  end
  def self.things
    node = self.roots.find_by_name("things").subtree.arrange
  end
end
