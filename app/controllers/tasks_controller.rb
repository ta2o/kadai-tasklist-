class TasksController < ApplicationController
  before_action :require_user_logged_in
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  before_action :correct_user, only: [:destroy]
  
  def index
     @tasks = Task.all.page(params[:page])
     if logged_in?
      @user = current_user
      @micropost = current_user.tasks.build  # form_for 用
      @microposts = current_user.tasks.order('created_at DESC').page(params[:page])
     end
  end     

  def show
  end

  def new
    @task = Task.new
  end

  def create
   @task = Task.new(task_params)
   @task = current_user.tasks.build(task_params)
    if @task.save
      flash[:success] = 'Task が正常に投稿されました'
      redirect_to @task
    else
      @tasks = current_user.tasks.order('created_at DESC').page(params[:page])
      flash.now[:danger] = 'Task が投稿されませんでした'
      render 'tasks/index'
    end
  end  

  def edit
  end 

  def update

    if @task.update(task_params)
      flash[:success] = 'Task は正常に更新されました'
      redirect_to @task
    else
      flash.now[:danger] = 'Task は更新されませんでした'
      render :edit
    end
  end

  def destroy
    @task.destroy

    flash[:success] = 'Taskは正常に削除されました'
    redirect_back(fallback_location: root_path)
  end

private

  def set_task
    @task = Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:content, :status)
  end
end

