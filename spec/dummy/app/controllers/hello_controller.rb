class HelloController < ApplicationController
  def hello
    respond_to do |format|
      format.html { render text: 'hello' }
      format.json { render json: { message: 'hello' }.to_json }
    end
  end

  def error
    raise StandardError, 'test error'
  end

  class TestError < StandardError; end
end
