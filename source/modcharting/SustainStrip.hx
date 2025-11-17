package modcharting;

import flixel.graphics.tile.FlxDrawTrianglesItem.DrawData;
import openfl.display.BitmapData;
import openfl.geom.Vector3D;
#if LEATHER
import game.Note;
#elseif (PSYCH && PSYCHVERSION >= "0.7")
import objects.Note;
#else
import Note;
#end
import flixel.FlxStrip;

class SustainStrip extends FlxStrip
{
    private static final noteUV:Array<Float> = [
        0,0, //top left
        1,0, //top right
        0,0.5, //half left
        1,0.5, //half right    
        0,1, //bottom left
        1,1, //bottom right 
    ];
    private static final noteIndices:Array<Int> = [
        0,1,2,1,3,2, 2,3,4,3,4,5
        //makes 4 triangles
    ];

    private var daNote:Note;

    override public function new(daNote:Note)
    {
        this.daNote = daNote;
        daNote.alpha = 1;
        super(0,0);
        final bitmap:BitmapData = daNote.graphic.bitmap.readable ? daNote.updateFramePixels() : daNote.graphic.bitmap;
        loadGraphic(bitmap);
        shader = daNote.shader;
        for (uv in noteUV)
        {
            uvtData.push(uv);
            vertices.push(0);
        }
        for (ind in noteIndices)
            indices.push(ind);
    }

    public function constructVertices(noteData:NotePositionData, thisNotePos:Vector3D, nextHalfNotePos:NotePositionData, nextNotePos:NotePositionData, flipGraphic:Bool, reverseClip:Bool)
	{
		var safeDenom = function(z:Float):Float {
			var denom = -z;
			if (denom <= 0.000001) denom = 0.000001;
			return denom;
		}

		var pointWidth = function(frameWidth:Float, z:Float, scaleX:Float):Float {
			return frameWidth * (1.0 / safeDenom(z)) * scaleX;
		}

		var startW = daNote.frameWidth * noteData.scaleX;
		var endW = daNote.frameWidth * nextNotePos.scaleX;
		var midW = pointWidth(daNote.frameWidth, nextHalfNotePos.z, nextHalfNotePos.scaleX);

		var verts:Array<Float> = [];

		if (flipGraphic)
		{
			verts.push(nextNotePos.x);
			verts.push(nextNotePos.y);
			verts.push(nextNotePos.x + endW);
			verts.push(nextNotePos.y);

			verts.push(nextHalfNotePos.x);
			verts.push(nextHalfNotePos.y);
			verts.push(nextHalfNotePos.x + midW);
			verts.push(nextHalfNotePos.y);

			verts.push(thisNotePos.x);
			verts.push(thisNotePos.y);
			verts.push(thisNotePos.x + startW);
			verts.push(thisNotePos.y);
		}
		else
		{
			verts.push(thisNotePos.x);
			verts.push(thisNotePos.y);
			verts.push(thisNotePos.x + startW);
			verts.push(thisNotePos.y);

			verts.push(nextHalfNotePos.x);
			verts.push(nextHalfNotePos.y);
			verts.push(nextHalfNotePos.x + midW);
			verts.push(nextHalfNotePos.y);

			verts.push(nextNotePos.x);
			verts.push(nextNotePos.y);
			verts.push(nextNotePos.x + endW);
			verts.push(nextNotePos.y);
		}

		vertices = new DrawData(12, true, verts);
	}
}