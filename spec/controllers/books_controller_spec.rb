require 'spec_helper'
require 'set'

describe BooksController do
  before(:all) { @book = create(:book) }

  context "index" do
    it "returns books" do
      get :index, format: :json
      books = parse_json(response.body)
      Set.new(books.first.keys).should == Set.new(@book.attributes.keys)
    end
  end

  context "show" do
    it "returns the book" do
      get :show, format: :json, id: @book.id
      book = parse_json(response.body)
      Set.new(book.keys).should == Set.new(@book.attributes.keys)
    end
  end

  context "create" do
    context "valid" do
      it "creates the record" do
        expect { post :create, book: attributes_for(:book) }.to change{Book.count}.from(1).to(2)
        response.status.should == 201
        response.header['Location'].should_not be_nil
      end
    end

    context "invalid" do
      it "doesn't create the record" do
        expect { post :create, book: {} }.to_not change{Book.count}.from(1).to(2)
        response.status.should == 400
        parse_json(response.body).should_not be_empty
      end
    end
  end

  context "update" do
    context "valid" do
      it "updates the record" do
        put :update, id: @book.id, book: attributes_for(:book)
        response.status.should == 200
      end
    end

    context "invalid" do
      it "doesn't update the record" do
        put :update, id: @book.id, book: {title: ""}
        response.status.should == 400
        parse_json(response.body).should_not be_empty
      end
    end
  end

  context "destroy" do
    it "should destroy the record" do
      expect { delete :destroy, id: @book.id }.to change{Book.count}.from(2).to(1)
      response.status.should == 200
    end
  end
end
