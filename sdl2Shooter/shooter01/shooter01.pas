{
  Opening a SDL2 - Window
  author: shenchunqian
  created: 2023-02-27
}

program Part1;

{$mode objfpc}
{$H+}

uses SDL2;

const
  SCREEN_WIDTH = 1280; {size of the grafic window}
  SCREEN_HEIGHT = 720; {size of the grafic window}

type {"T" short for "TYPE"}
  TApp = record
    Window: PSDL_Window;
    Renderer: PSDL_Renderer;
  end;

var
  app: TApp;
  event: TSDL_EVENT;
  exitLoop: BOOLEAN;

// DRAW

procedure prepareScene;
begin
  SDL_SetRenderDrawColor(app.Renderer, 96, 128, 255, 255);
  SDL_RenderClear(app.Renderer);
end;

procedure presentScene;
begin
  SDL_RenderPresent(app.Renderer);
end;

// INIT SDL

procedure initSDL;
var
  rendererFlags, windowFlags: integer;
begin
  rendererFlags := SDL_RENDERER_PRESENTVSYNC or SDL_RENDERER_ACCELERATED;
  windowFlags := 0;
  if SDL_Init(SDL_INIT_VIDEO) < 0 then
  begin
    writeln('Couldn''t initialize SDL');
    halt(1);
  end;

  app.Window := SDL_CreateWindow('Shooter 01',
                                  SDL_WINDOWPOS_UNDEFINED,
                                  SDL_WINDOWPOS_UNDEFINED,
                                  SCREEN_WIDTH,
                                  SCREEN_HEIGHT,
                                  windowFlags);
  if app.Window = NIL then
  begin
    writeln('Failed to open ', SCREEN_WIDTH, ' x ', SCREEN_HEIGHT, ' window');
    halt(1);
  end;

  app.Renderer := SDL_CreateRenderer(app.Window, -1, rendererFlags);
  if app.Renderer = NIL then
  begin
    writeln('Failed to create renderer');
    halt(1);
  end;
end;

procedure atExit;
begin
  SDL_DestroyRenderer(app.Renderer);
  SDL_DestroyWindow(app.Window);
  SDL_Quit;
  if Exitcode <> 0 then
    writeln(SDL_GetError());
end;

// Input

procedure doInput;
begin
  while SDL_PollEvent(@event) = 1 do
  begin
    case event.Type_ of
      SDL_QUITEV:
        exitLoop := TRUE; {close Window}
    end;
  end;
end;

// MAIN

begin
  InitSDL;
  AddExitProc(@atExit);
  exitLoop := FALSE;

  while exitLoop = FALSE do
  begin
    prepareScene;
    doInput;
    presentScene;
    SDL_Delay(16);
  end;

  atExit;
end.
