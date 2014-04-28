class GroupsController < ApplicationController

	before_action :login_required, :only => [:new, :create, :edit,:update,:destroy]

	def index
		@groups = Group.all
	end

	def show
		@group = Group.find(params[:id])
		if @group.nil?
			flash[:error] = "not found"
		else
			@posts = @group.posts
		end
	end

	def edit
		@group =  current_user.groups.find(params[:id])
	end

	def new
		@group = Group.new
	end

	def create
		@group = current_user.groups.build(group_params)
		if(@group.save)
			# current_user.join!(group)
			redirect_to groups_path
		else
			render :new
		end
	end

	def update
		@group =  current_user.groups.find(params[:id])

		if(@group.update(group_params))
			redirect_to groups_path(@group)
		else
			render :edit
		end
	end

	def destroy
	    #@group =  Group.find(params[:id]) 
	    @group =  current_user.groups.find(params[:id])
	    @group.destroy
	    redirect_to groups_path
	end

	def join
		@group = Group.find(params[:id])

		if !current_user.is_member_of?(@group)
			current_user.join!(@group)
		else
			flash[:waring] = "You are already in this group."
		end
		redirect_to groups(@group)
	end

	def quit
		@group = Group.find(params[:id])

		if current_user.is_member_of?(@group)
			current_user.quit!(@group)
		else
			flash[:waring] = "You are not in this group."
		end
		redirect_to groups_path(@group)
	end


	private

	def group_params
		params.require(:group).permit(:title , :description)
	end


end
