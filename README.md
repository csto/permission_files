Overview
--------
This is sample code that would find it's home in any small to enormous Rails application.  These files in a Rails app would be located in:

```
  app/controllers/application_controler.rb
  app/models/permission.rb
  spec/models/permission.rb
```
  
Controlling authorization is now in one place, easy to read, write and test.  If the authorization has to query a model, the model can be passed back to the application controller and instanciated to prevent multiple Model.find() lookups.
