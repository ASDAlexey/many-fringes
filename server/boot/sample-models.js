var linecategoryFixtures=require('../fixtures/linecategory.json');
var categoryFixtures=require('../fixtures/category.json');
var articleFixtures=require('../fixtures/articles.json');
var acticleImageFixtures=require('../fixtures/article-images.json');

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
  /*app.dataSources.relationalDB.automigrate('Linecategory',function(err){
    if(err) throw err;
    app.models.Linecategory.create(linecategoryFixtures,function(err,models){
      if(err) throw err;
      //console.log('Models created: \n',models);
    });
  });
  app.dataSources.relationalDB.automigrate('Category',function(err){
    if(err) throw err;
    app.models.Category.create(categoryFixtures,function(err,models){
      if(err) throw err;
      //console.log('Models created: \n',models);
    });
  });
  app.dataSources.relationalDB.automigrate('Article',function(err){
    if(err) throw err;
    app.models.Article.create(articleFixtures,function(err,models){
      if(err) throw err;
      //console.log('Models created: \n',models);
    });
  });
  app.dataSources.relationalDB.automigrate('LinecategoryImage',function(err){
    if(err) throw err;
    app.models.LinecategoryImage.create([{
      "src":"zodiac.jpg",
      "alt":"horoscopes",
      "width":null,
      "height":null,
      "created_at":0,
      "updated_at":0,
      "linecategoryId":1
    }],function(err,models){
      if(err) throw err;
      //console.log('Models created: \n',models);
    });
  });
  app.dataSources.relationalDB.automigrate('CategoryImage',function(err){
    if(err) throw err;
    app.models.CategoryImage.create([{
      "src":"zodiac.jpg",
      "alt":"horoscopes",
      "width":null,
      "height":null,
      "created_at":0,
      "updated_at":0,
      "categoryId":1
    }],function(err,models){
      if(err) throw err;
      //console.log('Models created: \n',models);
    });
  });
  app.dataSources.relationalDB.automigrate('ArticleImage',function(err){
    if(err) throw err;
    app.models.ArticleImage.create(acticleImageFixtures,function(err,models){
      if(err) throw err;
      //console.log('Models created: \n',models);
    });
  });*/
};
