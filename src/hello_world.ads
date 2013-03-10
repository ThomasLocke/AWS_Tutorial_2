with AWS.Dispatchers.Callback;
with AWS.MIME;
with AWS.Response;
with AWS.Status;

package Hello_World is

   function Callback
     return AWS.Dispatchers.Callback.Handler;
   --  Return a callback for the Hello World! response.

   function Hello_World_Template
     (Request : in AWS.Status.Data)
      return AWS.Response.Data
   is (AWS.Response.File (AWS.MIME.Text_Plain,
                          "templates/hello_world.tmpl"));

end Hello_World;
