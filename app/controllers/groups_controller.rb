class GroupsController < ApplicationController

  before_action :authenticate_user!
  # 下記がないとRouting Errorになる
  before_action :ensure_correct_user, only: [:edit, :update]

  def new
    @group = Group.new
  end

  def create
    @group = Group.new(group_params)
    @group.owner_id = current_user.id
    # @group.usersに、current_userを追加しているということ。
    # @group.users << current_userの記述がないとグループ作成者がメンバーに含まれなくなる。
    @group.users << current_user
    if @group.save
      redirect_to groups_path
    else
      render :new
    end
  end

  def index
    @book = Book.new
    @groups = Group.all
  end

  def show
    @book = Book.new
    @group = Group.find(params[:id])
  end

  def edit
  end

  def update
    if @group.update(group_params)
      redirect_to groups_path
    else
      render :edit
    end
  end

  def destroy
    @group = Group.find(params[:id])
    # current_userは、@group.usersから消されるという記述。
    @group.users.delete(current_user)
    redirect_to groups_path
  end

  def join
    @group = Group.find(params[:group_id])
    # @group.usersに、current_userを追加しているということ。
    # @group.users << current_userの記述がないとメンバーがグループに参加することができない。
    @group.users << current_user
    redirect_to groups_path
  end

  private

  def group_params
    params.require(:group).permit(:name, :introduction, :group_image)
  end

 # 下記がないとRouting Errorになる
  def ensure_correct_user
    @group = Group.find(params[:id])
    unless @group.owner_id == current_user.id
      redirect_to groups_path
    end
  end

end
