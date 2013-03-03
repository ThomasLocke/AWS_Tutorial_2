with AWS.Messages;
with AWS.MIME;
with AWS.Response;
with AWS.Status;
with AWS.Templates;

package body Hello_World is

   function Generate_Content
     (Request : in AWS.Status.Data)
      return AWS.Response.Data;
   --  Generate the Hello World! response.

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

      type Natural_List is array (0 .. 9) of Natural;
      Fibs : Natural_List;

      Browser : constant String := AWS.Status.User_Agent (Request);

      Fibonacci    : Vector_Tag;
      Position     : Vector_Tag;
      Translations : Translate_Set;
   begin
      Insert (Translations, Assoc ("BROWSER", Browser));

      for i in Fibs'Range loop
         case i is
            when 0 => Fibs (i) := 0;
            when 1 => Fibs (i) := 1;
            when others => Fibs (i) := Fibs (i - 1) + Fibs (i - 2);
         end case;

         Append (Position, i);
         Append (Fibonacci, Fibs (i));
      end loop;

      Insert (Translations, Assoc ("POSITION", Position));
      Insert (Translations, Assoc ("FIBONACCI", Fibonacci));

      return AWS.Response.Build
        (Content_Type  => AWS.MIME.Text_HTML,
         Message_Body  => Parse (Filename     => "templates/hello_world.tmpl",
                                 Translations => Translations,
                                 Cached       => True),
         Status_Code   => AWS.Messages.S200);
   end Generate_Content;

end Hello_World;
