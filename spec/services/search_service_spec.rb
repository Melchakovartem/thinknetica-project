require "rails_helper"

RSpec.describe SearchService do
  describe "search" do

    it "searchs everywhere" do
      expect(ThinkingSphinx::Query).to receive(:escape).with("test").and_call_original
      expect(ThinkingSphinx).to receive(:search).with("test")
      SearchService.call("test", "")
    end

    %w(Question Answer Comment User).each do |model|
      it "searchs in #{model}" do
        expect(ThinkingSphinx::Query).to receive(:escape).with("test").and_call_original
        expect(model.constantize).to receive(:search).with("test")
        SearchService.call("test", model)
      end
    end
  end
end
