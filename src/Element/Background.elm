module Element.Background exposing
    ( color, gradient
    , image, uncropped, tiled, tiledX, tiledY
    )

{-|

@docs color, gradient


# Images

@docs image, uncropped, tiled, tiledX, tiledY

**Note** if you want more control over a background image than is provided here, you should try just using a normal `Element.image` with something like `Element.behindContent`.

-}

import Animator
import Element exposing (Attribute, Color)
import Html.Attributes as Attr
import Internal.Flag2 as Flag
import Internal.Model2 as Two
import Internal.Style2 as Style


{-| -}
color : Color -> Two.Attribute msg
color (Style.Rgb red green blue) =
    Two.Attr
        (Attr.style "background-color"
            ("rgb("
                ++ String.fromInt red
                ++ ("," ++ String.fromInt green)
                ++ ("," ++ String.fromInt blue)
                ++ ")"
            )
        )


{-| Resize the image to fit the containing element while maintaining proportions and cropping the overflow.
-}
image : String -> Attribute msg
image src =
    Two.Attr
        (Attr.style "background"
            ("url(\"" ++ src ++ "\") center / cover no-repeat")
        )


{-| A centered background image that keeps its natural proportions, but scales to fit the space.
-}
uncropped : String -> Attribute msg
uncropped src =
    Two.Attr
        (Attr.style "background"
            ("url(\"" ++ src ++ "\") center / contain no-repeat")
        )


{-| Tile an image in the x and y axes.
-}
tiled : String -> Attribute msg
tiled src =
    Two.Attr
        (Attr.style "background"
            ("url(\"" ++ src ++ "\") center / repeat")
        )


{-| Tile an image in the x axis.
-}
tiledX : String -> Attribute msg
tiledX src =
    Two.Attr
        (Attr.style "background"
            ("url(\"" ++ src ++ "\") center / repeat-x")
        )


{-| Tile an image in the y axis.
-}
tiledY : String -> Attribute msg
tiledY src =
    Two.Attr
        (Attr.style "background"
            ("url(\"" ++ src ++ "\") center / repeat-y")
        )


type Direction
    = ToUp
    | ToDown
    | ToRight
    | ToTopRight
    | ToBottomRight
    | ToLeft
    | ToTopLeft
    | ToBottomLeft
    | ToAngle Float


type Step
    = ColorStep Color
    | PercentStep Float Color
    | PxStep Int Color


{-| -}
step : Color -> Step
step =
    ColorStep


{-| -}
percent : Float -> Color -> Step
percent =
    PercentStep


{-| -}
px : Int -> Color -> Step
px =
    PxStep


{-| A linear gradient.

First you need to specify what direction the gradient is going by providing an angle in radians. `0` is up and `pi` is down.

The colors will be evenly spaced.

-}
gradient :
    { angle : Float
    , steps : List Color
    }
    -> Attribute msg
gradient { angle, steps } =
    case steps of
        [] ->
            Two.NoAttribute

        (Style.Rgb red green blue) :: [] ->
            Two.Attr
                (Attr.style "background-color"
                    ("rgb("
                        ++ String.fromInt red
                        ++ ("," ++ String.fromInt green)
                        ++ ("," ++ String.fromInt blue)
                        ++ ")"
                    )
                )

        _ ->
            Two.Attr
                (Attr.style "background-image"
                    ("linear-gradient("
                        ++ (String.join ", " <| (String.fromFloat angle ++ "rad") :: List.map Style.color steps)
                        ++ ")"
                    )
                )



-- {-| -}
-- gradientWith : { direction : Direction, steps : List Step } -> Attribute msg
-- gradientWith { direction, steps } =
--     StyleClass <|
--         Single ("bg-gradient-" ++ (String.join "-" <| renderDirectionClass direction :: List.map renderStepClass steps))
--             "background"
--             ("linear-gradient(" ++ (String.join ", " <| renderDirection direction :: List.map renderStep steps) ++ ")")
-- {-| -}
-- renderStep : Step -> String
-- renderStep step =
--     case step of
--         ColorStep color ->
--             formatColor color
--         PercentStep percent color ->
--             formatColor color ++ " " ++ toString percent ++ "%"
--         PxStep px color ->
--             formatColor color ++ " " ++ toString px ++ "px"
-- {-| -}
-- renderStepClass : Step -> String
-- renderStepClass step =
--     case step of
--         ColorStep color ->
--             formatColorClass color
--         PercentStep percent color ->
--             formatColorClass color ++ "-" ++ floatClass percent ++ "p"
--         PxStep px color ->
--             formatColorClass color ++ "-" ++ toString px ++ "px"
-- toUp : Direction
-- toUp =
--     ToUp
-- toDown : Direction
-- toDown =
--     ToDown
-- toRight : Direction
-- toRight =
--     ToRight
-- toTopRight : Direction
-- toTopRight =
--     ToTopRight
-- toBottomRight : Direction
-- toBottomRight =
--     ToBottomRight
-- toLeft : Direction
-- toLeft =
--     ToLeft
-- toTopLeft : Direction
-- toTopLeft =
--     ToTopLeft
-- toBottomLeft : Direction
-- toBottomLeft =
--     ToBottomLeft
-- angle : Float -> Direction
-- angle rad =
--     ToAngle rad
-- renderDirection : Direction -> String
-- renderDirection dir =
--     case dir of
--         ToUp ->
--             "to top"
--         ToDown ->
--             "to bottom"
--         ToRight ->
--             "to right"
--         ToTopRight ->
--             "to top right"
--         ToBottomRight ->
--             "to bottom right"
--         ToLeft ->
--             "to left"
--         ToTopLeft ->
--             "to top left"
--         ToBottomLeft ->
--             "to bottom left"
--         ToAngle angle ->
--             toString angle ++ "rad"
-- renderDirectionClass : Direction -> String
-- renderDirectionClass dir =
--     case dir of
--         ToUp ->
--             "to-top"
--         ToDown ->
--             "to-bottom"
--         ToRight ->
--             "to-right"
--         ToTopRight ->
--             "to-top-right"
--         ToBottomRight ->
--             "to-bottom-right"
--         ToLeft ->
--             "to-left"
--         ToTopLeft ->
--             "to-top-left"
--         ToBottomLeft ->
--             "to-bottom-left"
--         ToAngle angle ->
--             floatClass angle ++ "rad"
