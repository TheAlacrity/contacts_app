class Api::ContactsController < ApplicationController
  def index
    p current_user
    if current_user
      @contacts = current_user.contacts

      search_term = params[:name]
      if search_term
        @contacts = @contacts.where(
                                    "first_name iLIKE ? OR last_name iLIKE OR middle_name iLIKE ? OR bio iLIKE ? OR email iLIKE ?",
                                    "%#{search_term}%",
                                    "%#{search_term}%",
                                    "%#{search_term}%",
                                    "%#{search_term}%",
                                    "%#{search_term}%"
                                    )
      end

    render 'index.json.jbuilder'
    else
      render json: []
    end
  end

  def create
    @contact = Contact.new(
                          first_name: params[:first_name],
                          last_name: params[:last_name],
                          middle_name: params[:middle_name],
                          email: params[:email],
                          phone_number: params[:phone_number],
                          bio: params[:bio],
                          user_id: current_user.id
                          )
    

    if @contact.save
      render 'show.json.jbuilder'
    else
      render json: { message: @contact.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def show
    @contact = Contact.find(params[:id])
    render 'show.json.jbuilder'
  end

  def update
    @contact = Contact.find(params[:id])

    @contact.first_name = params[:first_name] || @contact.first_name
    @contact.last_name = params[:last_name] || @contact.last_name
    @contact.email = params[:email] || @contact.email
    @contact.phone_number = params[:phone_number] || @contact.phone_number
    @contact.middle_name = params[:middle_name] || @contact.middle_name

    if @contact.save
      render 'show.json.jbuilder'
    else
      render json: { message: @contact.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @contact = Contact.find(params[:id])
    @contact.destroy

    render json: {message: "Successfully destroyed contact #{@contact.first_name} #{@contact.last_name} with ID #{@contact.id}"}
  end
end
