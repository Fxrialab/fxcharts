package fxrialab.utils 
{
	import flash.display.GraphicsPathCommand;
	import flash.display.Sprite;
	import flash.text.TextField;
	
	import mx.effects.Tween;
	
	public class DrawHelper extends Sprite
	{		
		public function DrawHelper() {
			super();
		}
		
		public static function Tooltip(w:Number, h:Number, backgroundColor:uint):Sprite
		{
			 var tt:Sprite = new Sprite();
			 tt.graphics.beginFill(backgroundColor, 1);  
			 tt.graphics.drawRoundRect(0, 0, w, h, 10, 10);  
			 
			 tt.graphics.moveTo(tt.width / 2 - 6, tt.height);  
			 tt.graphics.lineTo(tt.width / 2, tt.height + 4.5);  
			 tt.graphics.lineTo(tt.width / 2 + 6, tt.height - 4.5);  
			 
			 tt.graphics.endFill();
			 
			 return tt;
		}
		
		public static function Arc(centerX:Number, centerY:Number, radius:Number, startAngle:Number, arcAngle:Number) :Vector.<Object>
		{
			startAngle = startAngle/360;
			var twoPI:Number = 2*Math.PI;	
			var step:Number = 50;
			
			var angleStep:Number = arcAngle/step;
			var commands:Vector.<Object> = new Vector.<Object>();
			
			var startPointX:Number = centerX + Math.cos(startAngle*twoPI) * radius;
			var startPointY:Number = centerY + Math.sin(startAngle*twoPI) * radius;
			
			commands.push({command:GraphicsPathCommand.MOVE_TO, x:startPointX,y:startPointY});
			
			for(var i:int=1; i<=step; i++){
				var angle:Number = startAngle + i * angleStep;
				var endPointX:Number = centerX + Math.cos(angle*twoPI) * radius;
				var endPointY:Number = centerY + Math.sin(angle*twoPI) * radius;
				
				commands.push({command:GraphicsPathCommand.LINE_TO, x:endPointX,y:endPointY});
			}
			commands.push({command:GraphicsPathCommand.LINE_TO, x:centerX,y:centerY});
			commands.push({command:GraphicsPathCommand.LINE_TO, x:startPointX,y:startPointY});
			
			return commands;
		}
		
		public static function SolidArc(centerX:Number, centerY:Number, innerRadius:Number, outerRadius:Number, startAngle:Number, arcAngle:Number) :Vector.<Object>
		{
			startAngle = startAngle / 360;
			// Used to convert angles to radians.
			var twoPI:Number = 2 * Math.PI;
			var step:Number = 50;
			// How much to rotate for each point along the arc.
			var angleStep:Number = arcAngle / step;
			var commands:Vector.<Object>  = new Vector.<Object>();
			// Variables set later.
			var angle:Number, endAngle:Number;
			// Find the coordinates of the first point on the inner arc.
			var pointX:Number = centerX + Math.cos(startAngle * twoPI) * innerRadius;
			var pointY:Number = centerY + Math.sin(startAngle * twoPI) * innerRadius;
			// Store the coordiantes in an object.
			var startPoint:Object = {x:pointX, y:pointY};
			// Move to the first point on the inner arc.
			commands.push({command:GraphicsPathCommand.MOVE_TO, x:pointX, y:pointY});
			// Draw all of the other points along the inner arc.
			for(var i:int=1; i<=step; i++){
				angle = (startAngle + i * angleStep) * twoPI;
				
				pointX = centerX + Math.cos(angle) * innerRadius;
				pointY = centerY + Math.sin(angle) * innerRadius;
				
				commands.push({command:GraphicsPathCommand.LINE_TO, x:pointX, y:pointY});
			}
			// Determine the ending angle of the arc so you can
			// rotate around the outer arc in the opposite direction.
			endAngle = startAngle + arcAngle;
			// Start drawing all points on the outer arc.
			for(i=0; i<=step; i++){
				// To go the opposite direction, we subtract rather than add.
				angle = (endAngle - i * angleStep) * twoPI;
				
				pointX = centerX + Math.cos(angle) * outerRadius;
				pointY = centerY + Math.sin(angle) * outerRadius;
				
				commands.push({command:GraphicsPathCommand.LINE_TO, x:pointX, y:pointY});
			}
			// Close the shape by drawing a straight
			// line back to the inner arc.
			commands.push( { command:GraphicsPathCommand.LINE_TO, x:startPoint.x, y:startPoint.y } );
			
			return commands;
		}
		
	}

}