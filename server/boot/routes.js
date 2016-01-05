module.exports=function(app){
  var router=app.loopback.Router();

  router.get('/',function(req,res){
    res.render('index',{});
  });

  router.get('/admin',function(req,res){
    res.render('login');
  });

  router.post('/admin',function(req,res){
    var email=req.body.email;
    var password=req.body.password;
    console.log('email'+email);
    console.log('password'+password);
    app.models.User.login({
      email:email,
      password:password
    },'user',function(err,token){
      if(err){
        return res.render('login',{
          email:email,
          password:password
        });
      }
      token=token.toJSON();

      res.render('admin',{
        username:token.user.username,
        accessToken:token.id
      });
    });
  });

  router.get('/logout',function(req,res){
    var AccessToken=app.models.AccessToken;
    var token=new AccessToken({id:req.query['access_token']});
    token.destroy();
    res.redirect('/admin');
  });

  app.use(router);
};
