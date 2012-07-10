require 'spec_helper'

describe SchoolsController do
  context "HTML" do
    describe "create" do
      it "returns 201 and sets the location header" do
        expect { post :create, school: attributes_for(:school) }.to change{School.count}.from(0).to(1)
        response.status.should eq(201)
        response.header['Location'].should_not be_nil
      end
    end

    describe "index" do
      it "renders the template and returns 200" do
        get :index
        response.should render_template(:index)
        response.status.should eq(200)
      end
    end

    describe "show" do
      it "renders the template and returns 200" do
        get :show, id: 1
        response.should render_template(:show)
        response.status.should eq(200)
      end
    end

    describe "update" do
      it "returns 200" do
        put :update, id: 1, school: attributes_for(:school)
        response.status.should eq(200)
      end
    end

    describe "destroy" do
      it "returns 200" do
        expect { delete :destroy, id: 1 }.to change{School.count}.from(1).to(0)
        response.status.should eq(200)
      end
    end
  end

  context "JSON" do
    it "should be able to put this in the before block, but can't" do
      post :create, school: attributes_for(:school)
    end

    describe "index" do
      it "returns JSON response" do
        get :index, :format => :json
        response.header['Content-Type'].should match(/application\/json/)
        expect { JSON.parse(response.body) }.to_not raise_exception
      end
    end

    describe "show" do
      it "returns a JSON response" do
        get :show, id: 2, :format => :json
        response.header['Content-Type'].should match(/application\/json/)
        expect { JSON.parse(response.body) }.to_not raise_exception
      end
    end
  end
end
