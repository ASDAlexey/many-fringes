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
  /*app.dataSources.relationalDB.automigrate('Linecategories',function(err){
   if(err) throw err;

   app.models.linecategories.create([
   {
   "name":"Гороскопы",
   "slug":"horoscopes",
   "order":1,
   "title":"string",
   "keywords":"keywords-horoscopes",
   "description":"description-horoscopes",
   "created_at":0,
   "updated_at":0
   }
   ],function(err,models){
   if(err) throw err;

   console.log('Models created: \n',models);
   });
   });
   */
  app.dataSources.relationalDB.automigrate('Category',function(err){
    if(err) throw err;
    app.models.Category.create([{
      "name":"Японский гороскоп555777",
      "slug":"japanese_horoscope",
      "order":1,
      "title":"title-japanese_horoscope",
      "keywords":"keywords-japanese_horoscope",
      "description":"description-japanese_horoscope",
      "created_at":0,
      "updated_at":0,
      "linecategoryId":1
    }],function(err,models){
      if(err) throw err;
      //console.log('Models created: \n',models);
    });
  });
  /*app.dataSources.relationalDB.automigrate('CategoryImage',function(err){
   if(err) throw err;
   app.models.CategoryImage.create([{
   "name":"Японский гороскоп",
   "slug":"japanese_horoscope",
   "order":1,
   "title":"title-japanese_horoscope",
   "keywords":"keywords-japanese_horoscope",
   "description":"description-japanese_horoscope",
   "created_at":0,
   "updated_at":0
   }],function(err,models){
   if(err) throw err;
   console.log('Models created: \n',models);
   });
   });*/
  /*app.dataSources.relationalDB.automigrate('CategoryImage',function(err){
   if(err) throw err;
   app.models.CategoryImage.create([{
   "src":"zodiac.jpg",
   "alt":"horoscopes",
   "width":null,
   "height":null,
   "created_at":0,
   "updated_at":0,
   "linecategoryId":1
   }],function(err,models){
   if(err) throw err;
   console.log('Models created: \n',models);
   });
   });*/
};
