class PostsController < ApplicationController
	before_action :login_required, :only => [:new,:creat,:edit,:update,:destroy]
	before_action :member_required
	before_action :find_group
	def new
		@post = @group.posts.build
	end
	def create

		@post = @group.posts.new(post_params)
		@post.author = current_user

		if @post.save
			redirect_to group_path(@group)
		else
			render :new
		end
	end
	def edit
		@post = @group.posts.find(params[:id])
	end
	def update
		@post = @group.posts.find(params[:id])
		if @post.update(post_params)
			redirect_to group_path(@group)
		else
			render :edit
		end
	end
	def destroy

		@post = @group.posts.find(params[:id])
		@post.destroy
		redirect_to group_path(@group)
	end


	private
	
	def find_group
		# this action is before_action
		# find the current group via group_id .
		@group = Group.find(params[:group_id])
	end 

	def post_params
		#
		params.require(:post).permit(:content)
	end

	def member_required
		if !current_user.is_member_of?(@group)
			flash[:warning] = "You are not a member of this group!"
			redirect_to group_path(@group)
		end
	end

end
