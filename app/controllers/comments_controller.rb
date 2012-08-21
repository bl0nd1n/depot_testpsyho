# app/controllers/comments_controller.rb
	class CommentsController < ApplicationController
	  before_filter :get_parent
	   
	  def new
	    @comment = @parent.comments.build
	  end
	 
	  def create
	    @comment = @parent.comments.build(params[:comment])
	     
	    if @comment.save
	      redirect_to mypost_path(@comment.mypost), :notice => 'Thank you for your comment!'
	    else
	      render :new
	    end
	  end
	 
	  protected
	   
	  def get_parent
	    @parent = Mypost.find_by_id(params[:mypost_id]) if params[:mypost_id]
	    @parent = Comment.find_by_id(params[:comment_id]) if params[:comment_id]
	     
    redirect_to root_path unless defined?(@parent)
	  end
	end