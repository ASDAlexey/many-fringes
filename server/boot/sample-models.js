module.exports=function(app){
  var User=app.models.user;
  var Role=app.models.Role;
  var RoleMapping=app.models.RoleMapping;
  var Team=app.models.Team;
  User.create([
    {email:"asdalexey@yandex.ru",password:"123"}
  ],function(err,users){
    if(err) throw err;
    //create the admin role
    Role.create({
      name:'admin'
    },function(err,role){
      if(err) throw err;
      //make bob an admin
      role.principals.create({
        principalType:RoleMapping.USER,
        principalId:users[0].id
      },function(err,principal){
        if(err) throw err;
      });
    });
  });
};
