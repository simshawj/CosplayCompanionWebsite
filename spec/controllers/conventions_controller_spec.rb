require 'rails_helper'

describe ConventionsController do
  let(:invalid_convention_attribs) { FactoryGirl.attributes_for(:convention, name: nil) }
  let(:convention_attribs) { FactoryGirl.attributes_for(:convention) }
  let(:convention) { FactoryGirl.create(:convention) }
  let(:id) { convention.id }
  let(:second_valid_convention_name) { "A new convention" }
  let(:second_valid_convention_attribs) { FactoryGirl.attributes_for(:convention, name: second_valid_convention_name) }

  describe "GET #index" do
    context "as html" do
      before(:each) { get :index }
      it "renders the :index view" do
        expect(response).to render_template :index
      end
      it "creates a list of Conventions" do
        expect(assigns(:conventions)).to eq([convention])
      end
    end
    context "as json" do
      before(:each) { 
        convention
        get :index, :format => :json 
      }
      it "responds with the convention as json" do
        expect(response.body).to eq([convention].to_json)
      end

    end
  end

  describe "GET #new" do
    before(:each) { get :new }
    it "renders the :new view" do
      expect(response).to render_template :new
    end
    it "creates a new Convention" do
      expect(assigns(:convention)).to be_a_new(Convention)
    end
  end

  describe "GET #new.js" do
    before(:each) { xhr :get, :new, format: :js }
    it "returns the javascript view" do
      expect(response.content_type).to eq(Mime::JS)
    end
    it "creates a new Convention" do
      expect(assigns(:convention)).to be_a_new(Convention)
    end
  end

  describe "POST #create" do
    context "with a valid convention" do
      it "redirects to the :index view" do
        post :create, convention: convention_attribs
        expect(response).to redirect_to action: "index"
      end
      it "saves a Convention" do
        expect{post :create, convention: convention_attribs}.to change{Convention.count}.by(1)
      end
      it "sets flash success message" do
        post :create, convention: convention_attribs
        expect(flash[:success]).to be_present
      end
    end

    context "with an invalid convention" do
      it "redirects to the :new view" do
        post :create, convention: invalid_convention_attribs
        expect(response).to render_template :new
      end
      it "does not save a Convention" do
        expect{post :create, convention: invalid_convention_attribs}.not_to change{Convention.count}
      end
      it "sets flash alert message" do
        post :create, convention: invalid_convention_attribs
        expect(flash[:alert]).to be_present
      end
    end
  end

  describe "POST #create.js" do
    context "with a valid convention" do
      it "renders a JS response" do
        xhr :post, :create, convention: convention_attribs, format: :js
        expect(response.content_type).to eq(Mime::JS)
      end
      it "saves a convention" do
        expect{ xhr :post, :create, convention: convention_attribs, format: :js }.to change{Convention.count}.by(1)
      end
      it "sets flash success message" do
        xhr :post, :create, convention: convention_attribs, format: :js
        expect(flash.now[:success]).to be_present
      end
    end

    context "with an invalid convention" do
      it "renders a JS response" do
        xhr :post, :create, convention: invalid_convention_attribs, format: :js
        expect(response.content_type).to eq(Mime::JS)
      end
      it "does not save a convention" do
        expect{ xhr :post, :create, convention: invalid_convention_attribs, format: :js }.not_to change{Convention.count}
      end
    end
  end

  describe "GET #show" do
    context "with a valid id" do
      before(:each) { get :show, id: id }
      it "renders the :show view" do
        expect(response).to render_template :show
      end
      it "retrieves a Convention" do
        expect(assigns(:convention)).to eq(convention)
      end
    end

    context "with an invalid id" do
      before(:each) do
        convention.delete
        get :show, id: id
      end
      it "redirects to the :index view" do
        expect(response).to redirect_to action: "index"
      end
      it "sets flash alert message" do
        expect(flash[:alert]).to be_present
      end
    end
  end

  describe "GET #edit" do
    context "with a valid id" do
      before(:each) { get :edit, id: id }
      it "renders the :edit iview" do
        expect(response).to render_template :edit
      end
      it "retrieves a Convention" do
        expect(assigns(:convention)).to eq(convention)
      end
    end

    context "with an invalid id" do
      before(:each) do
        convention.delete
        get :edit, id: id
      end
      it "redirects to the :index view" do
        expect(response).to redirect_to action: "index"
      end
      it "sets flash alert message" do
        expect(flash[:alert]).to be_present
      end
    end
  end

  describe "GET #edit.js" do
    context "with a valid id" do
      before(:each) { xhr :get, :edit, id: id, format: :js }
      it "reply with JavaScript" do
        expect(response.content_type).to eq(Mime::JS)
      end
      it "retrieves a Convention" do
        expect(assigns(:convention)).to eq(convention)
      end
    end

    context "with an invalid id" do
      before(:each) do
        convention.delete
        xhr :get, :edit, id: id, format: :js
      end
      it "redirects to the :index view" do
        expect(response).to redirect_to action: "index"
      end
      it "sets flash alert message" do
        expect(flash[:alert]).to be_present
      end
    end
  end


  describe "PUT #update" do
    context "with valid attributes" do
      before(:each) { session[:return_to] = conventions_path }
      it "redirects to the :index view" do
        put :update, id: id, convention: convention_attribs
        expect(response).to redirect_to action: "index"
      end
      it "modifies a Convention" do
        put :update, id: id, convention: second_valid_convention_attribs
        convention.reload
        expect(convention.name).to eq(second_valid_convention_name)
      end
      it "sets a successful flash message" do
        put :update, id: id, convention: second_valid_convention_attribs
        expect(flash[:success]).to be_present
      end
    end

    context "with invalid attributes" do
      it "redirects to the :edit view" do
        put :update, id: id, convention: invalid_convention_attribs
        expect(response).to render_template :edit
      end
      it "does not modify a Convention" do
        put :update, id: id, convention: invalid_convention_attribs
        convention.reload
        expect(convention.name).to eq("Test Convention")
      end
      it "sets an alert flash message" do
        put :update, id:id, convention: invalid_convention_attribs
        expect(flash[:alert]).to be_present
      end
    end
  end
end

