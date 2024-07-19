db.createUser(
    {
        user: "dicoDingoUser",
        pwd: "example",
        roles: [
            {
                role: "readWrite",
                db: "dicoDingo"
            }
        ]
    }
);
db.createCollection('articles');
db.createCollection('articles_archive');
db.dicoDingo.createIndex( { slug: 1 } )
db.dicoDingo.createIndex( { type: 1 } )
db.createCollection('user');
db.user.createIndex( { username: 1 } )
db.user.insertOne( {
    "username" : "dicoDingoTeam",
    "password" : "$2a$10$j6mZFq1fmPEcjuXtV3V.luyggwglCiH6p9xAtFTLkx0SidVFLxN26",
    "userRoles" : [
        {
            "role" : {
                "name" : "ROLE_SUPERADMIN"
            }
        }
    ],
    "_class" : "com.factory.dicoDingo.admin.entity.User"
} );

db.articles.createIndex(
  {
    'title': "text",
    'content.title': "text",
    'content.text': "text",
  }
)
