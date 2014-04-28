class Group < ActiveRecord::Base
	belongs_to :owner, :class_name => "User", :foreign_key => :user_id
	has_many :posts
	has_many :group_users
	has_many :members , :through => :group_users, :source => :user

	validates :title, :presence => true

	def editable_by?(user)
		user && user == owner
	end

	# a group creater should be a user in the group logically.
	after_create :join_owner_to_group

	def join_owner_to_group
		members << owner
	end
end