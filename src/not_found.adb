with AWS.Messages;
with AWS.MIME;
with AWS.Response;
with AWS.Status;
with AWS.Templates;

package body Not_Found is

   function Generate_Content
     (Request : in AWS.Status.Data)
      return AWS.Response.Data;
   --  Generate the 404 response.

   ----------------
   --  Callback  --
   ----------------

   function Callback
     return AWS.Dispatchers.Callback.Handler
   is
   begin
      return AWS.Dispatchers.Callback.Create (Generate_Content'Access);
   end Callback;

   ------------------------
   --  Generate_Content  --
   ------------------------

   function Generate_Content
     (Request : in AWS.Status.Data)
      return AWS.Response.Data
   is
      use AWS.Templates;

      Resource : constant String := AWS.Status.URI (Request);

      Translations : Translate_Set;
   begin
      Insert (Translations, Assoc ("RESOURCE", Resource));

      return AWS.Response.Build
        (Content_Type  => AWS.MIME.Text_HTML,
         Message_Body  => Parse ("templates/not_found.tmpl", Translations),
         Status_Code   => AWS.Messages.S404);
   end Generate_Content;

end Not_Found;
