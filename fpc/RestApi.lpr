program RestApi;

{$mode objfpc}{$H+}
uses
 {$IFDEF UNIX}cthreads, cmem,  {$ENDIF}
  SysUtils,
  Classes,
  fphttpapp,
  HTTPDefs,
  httproute,
  fpjson,
  jsonparser;

var
  aFileName: string;
  Data: TJSONData;
  albums: TJSONArray;
  fileStream: TFileStream;
  a: TStringList;

  procedure jsonResponse(var res: TResponse; Data: string);
  begin
    res.Content := Data;
    res.Code := 200;
    res.ContentType := 'application/json';
    res.ContentLength := length(res.Content);
    res.SendContent;
  end;

  procedure getAlbums(req: TRequest; res: TResponse);
  var
    jObject: TJSONObject;
  begin
    jObject := TJSONObject.Create;
    try
      jsonResponse(res, albums.AsJSON);
    finally
      jObject.Free;
    end;
  end;

  procedure getAlbum(req: TRequest; res: TResponse);
  var
    jObject: TJSONObject;
  begin
    jObject := TJSONObject.Create;
    try
      // NOT IMPLEMENTED
      jObject.Strings['greeting'] := 'Hello, ' + req.RouteParams['id'];
      jsonResponse(res, jObject.AsJSON);
    finally
      jObject.Free;
    end;
  end;

begin
  Application.Port := 8000;
  HTTPRouter.RegisterRoute('/albums', @getAlbums, True);
  HTTPRouter.RegisterRoute('/albums/:id', @getAlbum);
  Application.Threaded := True;
  Application.Initialize;

  // load the albums data
  aFileName := '../albums.json';
  fileStream := TFileStream.Create(aFileName, fmShareDenyNone);
  Data := GetJSON(fileStream);
  fileStream.Free();
  albums := Data.FindPath('') as TJSONArray;

  Application.Run;

end.
