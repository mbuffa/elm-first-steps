-- Show the current time in your time zone.
--
-- Read how it works:
--   https://guide.elm-lang.org/effects/time.html
--
-- For an analog clock, check out this SVG example:
--   https://elm-lang.org/examples/clock
--


module Clock exposing (..)

import Browser
import Html exposing (..)
import Html.Events exposing (..)
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Task
import Time



-- MAIN


main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


type alias Model =
    { zone : Time.Zone
    , time : Time.Posix
    , ticking : Bool
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( Model Time.utc (Time.millisToPosix 0) True
    , Task.perform AdjustTimeZone Time.here
    )



-- UPDATE


type Msg
    = Tick Time.Posix
    | AdjustTimeZone Time.Zone
    | PauseResume


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Tick newTime ->
            if model.ticking then
                ( { model | time = newTime }
                , Cmd.none
                )

            else
                ( model, Cmd.none )

        AdjustTimeZone newZone ->
            ( { model | zone = newZone }
            , Cmd.none
            )

        PauseResume ->
            ( { model | ticking = not model.ticking }
            , Cmd.none
            )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Time.every 1000 Tick



-- VIEW


view : Model -> Html Msg
view model =
    let
        hour =
            Time.toHour model.zone model.time

        minute =
            Time.toMinute model.zone model.time

        second =
            Time.toSecond model.zone model.time
    in
    div []
        [ svg
            [ width "120"
            , height "120"
            , viewBox "0 0 120 120"
            ]
            (List.concat [ alarmView, hourView hour, minuteView minute, secondView second ])
        , button [ onClick PauseResume ] [ Html.text "Pause/Resume" ]
        ]


alarmView : List (Svg Msg)
alarmView =
    [ circle
        [ cx "59"
        , cy "59"
        , r "50"
        , fill "white"
        , strokeWidth "3px"
        , stroke "black"
        ]
        []
    ]


hourView : Int -> List (Svg Msg)
hourView hour =
    let
        angle =
            String.fromInt (hour * 30 - 180)
    in
    [ rect
        [ x "59"
        , y "59"
        , width "2"
        , height "10"
        , fill "grey"
        , transform ("rotate(" ++ angle ++ " 59 59)")
        ]
        []
    ]


minuteView : Int -> List (Svg Msg)
minuteView minute =
    let
        angle =
            String.fromInt (minute * 6 - 180)
    in
    [ rect
        [ x "59"
        , y "59"
        , width "2"
        , height "30"
        , fill "black"
        , transform ("rotate(" ++ angle ++ " 59 59)")
        ]
        []
    ]


secondView : Int -> List (Svg Msg)
secondView second =
    let
        angle =
            String.fromInt (second * 6 - 180)
    in
    [ rect
        [ x "59"
        , y "49"
        , width "2"
        , height "50"
        , fill "red"
        , transform ("rotate(" ++ angle ++ " 59 59)")
        ]
        []
    ]
