package fxrialab.controls.charts
{
	import flash.display.Sprite;
	import flash.display.GradientType;
	import flash.geom.Matrix;
	
	public class VBarStackedSprite extends Sprite
	{
		public function VBarStackedSprite()
		{
			super();
		}
		
		private var _data:Object;
		
		public function get data():Object
		{
			return _data;
		}
		
		public function set data(value:Object):void
		{
			if(_data == value) return;
			_data = value;
		}
		
		public function draw():void 
		{
			//@TODO: still fix gradient for stacked of verticalBar
			var gradType:String = GradientType.LINEAR;
			var colors:Array = [data.fill, data.fill, data.fill];
			var alphas:Array = [0.3, 0.6, 1];
			var ratios:Array = [0, 128, 255];
			var matrix:Matrix = new Matrix();
			matrix.createGradientBox(data.value, data.barHeight, 0, data.marginLeft + data.sum - data.value, data.height - (data.gapCalc + data.barHeightCalc + data.marginBottom + data.offSet + data.barHeight));
			
			var bar:Sprite = new Sprite();
			bar.graphics.beginGradientFill(gradType, colors, alphas, ratios, matrix);
			bar.graphics.drawRect(data.marginLeft + data.sum - data.value, data.height - (data.gapCalc + data.barHeightCalc + data.marginBottom + data.offSet + data.barHeight), data.value, data.barHeight);
			bar.graphics.endFill();
			
			addChild(bar);
			//draw border
			var border:Sprite = new Sprite();
			border.graphics.lineStyle(2, 0xFFFFFF);
			border.graphics.moveTo(data.marginLeft + data.sum - data.value, data.height - (data.gapCalc + data.barHeightCalc + data.marginBottom + data.offSet + data.barHeight));
			border.graphics.lineTo(data.marginLeft + data.sum, data.height - (data.gapCalc + data.barHeightCalc + data.marginBottom + data.offSet + data.barHeight));
			border.graphics.lineTo(data.marginLeft + data.sum, data.height - (data.gapCalc + data.barHeightCalc + data.marginBottom + data.offSet));
			border.graphics.lineTo(data.marginLeft + data.sum - data.value, data.height - (data.gapCalc + data.barHeightCalc + data.marginBottom + data.offSet));
			
			addChild(border);
		}
	}
}