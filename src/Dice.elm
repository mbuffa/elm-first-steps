-- Press a button to generate a random number between 1 and 6.
--
-- Read how it works:
--   https://guide.elm-lang.org/effects/random.html
--
module Dice exposing (..)
import Browser
import Html exposing (..)
import Html.Events exposing (..)
import Random
import Svg exposing (..)
import Svg.Attributes exposing (..)



-- MAIN


main =
  Browser.element
    { init = init
    , update = update
    , subscriptions = subscriptions
    , view = view
    }



-- MODEL


type alias Model =
  { dieFace : Int
  }


init : () -> (Model, Cmd Msg)
init _ =
  ( Model 1
  , Cmd.none
  )



-- UPDATE


type Msg
  = Roll
  | NewFace Int


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Roll ->
      ( model
      , Random.generate NewFace (Random.int 1 6)
      )

    NewFace newFace ->
      ( Model newFace
      , Cmd.none
      )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none



-- VIEW


view : Model -> Html Msg
view model =
  div []
      [ button [ onClick Roll ] [ Html.text "Roll" ]
      , svg [ width "120"
            , height "120"
            , viewBox "0 0 120 120"
            ]
            (List.concat [dieRectView, dieFaceView model.dieFace])
      ]

dieRectView : List(Svg Msg)
dieRectView =
  [ rect
        [ x "10"
        , y "10"
        , width "100"
        , height "100"
        , rx "15"
        , ry "15"
        , fill "white"
        , strokeWidth "3px"
        , stroke "black"
        ]
        []
  ]

dieFaceView : number -> List(Svg Msg)
dieFaceView number =
  if number == 1 then
    [drawDot 60 60]
  else if number == 2 then
    [ drawDot 30 30
    , drawDot 90 90
    ]
  else if number == 3 then
    [ drawDot 30 30
    , drawDot 90 90
    , drawDot 60 60
    ]
  else if number == 4 then
    [ drawDot 30 30
    , drawDot 90 90
    , drawDot 30 90
    , drawDot 90 30
    ]
  else if number == 5 then
    [ drawDot 30 30
    , drawDot 90 90
    , drawDot 30 90
    , drawDot 90 30
    , drawDot 60 60
    ]
  else if number == 6 then
    [ drawDot 30 30
    , drawDot 90 90
    , drawDot 30 90
    , drawDot 90 30
    , drawDot 60 90
    , drawDot 60 30
    ]
  else
   []

drawDot : Int -> Int -> Svg Msg
drawDot x y =
  circle
    [ cx (String.fromInt x)
    , cy (String.fromInt y)
    , r "5"
    ]
    []
