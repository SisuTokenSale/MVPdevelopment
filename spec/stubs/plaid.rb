def stub_plaid_post
stub_request(:post, "https://sandbox.plaid.com/auth/get").
         with(
           body: "{\"access_token\":null,\"options\":{},\"client_id\":\"5bab5d496ae04e00139959c6\",\"secret\":\"9a1a79c362bed984829b882260a313\"}",
           headers: {
          'Accept'=>'*/*',
          'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'Content-Type'=>'application/json',
          'Plaid-Version'=>'2018-05-22',
          'User-Agent'=>'Plaid Ruby v6.1.0'
           }).
         to_return(status: 200, body: "", headers: {})
end
