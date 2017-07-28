shared_examples_for "API Authenticable" do
  context "unauthorized" do
    it "returns 401 status if there is no access_token" do
      do_request { request }
      expect(response.status).to eq 401
    end

    it "returns 401 status if acces_token is invalid" do
      do_request(acces_token: "12345") { request }
      expect(response.status).to eq 401
    end
  end
end
