class Api::V1::SocietiesController < ApplicationController
  before_action :authenticate_with_token!
  respond_to :json
  def index
    user = User.find(params[:slug])
    puts user.privacy_setting.business_list
    if user.nil?
      render json: nil, status: 204
    else
      if (user.privacy_setting.business_list == :only_me and params[:category] == '1') or (user.privacy_setting.friend_list == :only_me and params[:category] == '0')
        if user == current_user
          societies = user.societies.where(:status => 1, :category => params[:category]).page(params[:page]).per(20)
          json_societies = societies.as_json(:only => [:_id], :include => {:to => {:only => [:first_name, :last_name, :_id], :methods => [:slug], :include => {:business => {:only => [:name, :slug], :include => {:category => {:only => [:css]}}}}}}).each{|v|
            v['to']['id'] == current_user.id ? v['status_with_current_user'] = {:status => 'self'} : v['status_with_current_user'] = User.status_with_current_user(v['to']['id'], current_user)
          }
          render json: {:societies => json_societies, :next_page => societies.next_page}, status: 201
        else
          render json: {:societies => nil, :next_page => nil}, status: 201
        end
      end
      if (user.privacy_setting.business_list != :only_me and params[:category] == '1') or (user.privacy_setting.friend_list != :only_me and params[:category] == '0')
        societies = user.societies.where(:status => 1, :category => params[:category]).page(params[:page]).per(20)
        json_societies = societies.as_json(:only => [:_id], :include => {:to => {:only => [:first_name, :last_name, :_id], :methods => [:slug], :include => {:business => {:only => [:name, :slug], :include => {:category => {:only => [:css]}}}}}}).each{|v|
          v['to']['id'] == current_user.id ? v['status_with_current_user'] = {:status => 'self'} : v['status_with_current_user'] = User.status_with_current_user(v['to']['id'], current_user)
        }
        render json: {:societies => json_societies, :next_page => societies.next_page}, status: 201
      end
    end
  end
  def create
    if Society.where(:to_id => current_user.id, :user_id => params[:society][:to_id]).length == 0
      society = Society.new(society_params)
      society.user = current_user
      society.status = 0
      if society.save
        render json: society.as_json(:only => [:category, :_id], :include => {:to => {:only => [:_id], :include => {:business => {:only => [:name]}}}}), status: 201
      else
        render json: { errors: society.errors.full_messages() }, status: 202
      end
    else
      render :json => nil
    end
  end

  def search_received_requests
    received_requests = Society.where(:to_id => current_user.id, :status => 0).page(params[:page]).per(20)
    render :json => {:received_requests => received_requests.as_json(:only => [:category, :_id], :include => {:user => {:only => [:first_name, :last_name, :_id], :methods => [:slug], :include => {:business => {:only => [:name, :slug], :include => {:category => {:only => [:css]}}}}}}), :next_page => received_requests.next_page}
  end

  def search_sent_requests
    sent_requests = Society.where(:user_id => current_user.id, :status => 0).page(params[:page]).per(20)
    render :json => {:sent_requests => sent_requests.as_json(:only => [:category, :_id], :include => {:to => {:only => [:first_name, :last_name, :_id], :methods => [:slug], :include => {:business => {:only => [:name, :slug], :include => {:category => {:only => [:css]}}}}}}), :next_page => sent_requests.next_page}
  end
  def destroy
    society = Society.find(params[:id])
    if society and society.to_id == current_user.id
      user = society.user
      society.destroy
      render :json => user.as_json(:only => [:_id], :include => {:business => {:only => [:name]}}), status: 201
    else
      head 204
    end
  end

  def cancel_request
    society = Society.find(params[:id])
    puts current_user.id
    puts society.user_id
    if society and society.user_id == current_user.id and society.to_id.to_s == params[:society][:to_id].to_s and Society.where(:to_id => current_user.id, :user_id => params[:society][:to_id]).length == 0
      puts 'haahaaa'
      to = society.to
      society.destroy
      render :json => to.as_json(:only => [:_id], :include => {:business => {:only => [:name]}}), status: 201
    else
      puts 'baba'
      head 204
    end
  end
  def delete
    from = Society.find(params[:from])
    to = Society.find_by(:user_id => from.to.id ,:to_id => from.user.id, :status => from.status, :category => from.category)
    if from.present? and to.present? and ((from.user == current_user and  from.user == to.to and from.to == to.user) or (from.to == current_user and  from.to == to.user and from.user == to.to))
      from.user == current_user ? to_user = from.to : to_user = from.user
      from.destroy
      to.destroy
      render :json => to_user.as_json(:only => [:_id], :include => {:business => {:only => [:name]}}), status: 201
    else
      head 204
    end
  end
  def confirm
    society = Society.find(params[:id])
    if society and society.to_id == current_user.id and society.category == params[:category].to_i and society.status == 0
      society.update_attributes(:status => 1)
      co_society = Society.new(:category => society.category, :status => 1)
      co_society.user = current_user
      co_society.to = society.user
      if co_society.save
        render json: {:from => co_society.id, :to_id => society.user.id, :category => society.category}, status: 201
      else
        render json: { errors: society.errors.full_messages() }, status: 202
      end
    else
      render :json => nil
    end
  end

  def update
    society = Society.find(params[:id])
    if society.present? and society.user_id == current_user.id and society.to_id.to_s == params[:society][:to_id].to_s and Society.where(:to_id => current_user.id, :user_id => params[:society][:to_id]).length == 0
      if society.update_attributes(:category => params[:society][:category])
        render json: society.as_json(:only => [:_id, :category]), status: 201
      else
        render json: { errors: society.errors.full_messages() }, status: 202
      end
    else
      head 404
    end
  end
  private

  def society_params
    params.require(:society).permit(:to_id, :category)
  end
end
