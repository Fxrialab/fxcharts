package fxrialab.controls.charts.legend
{
	import flash.display.Sprite;
	import flash.text.TextField;
	
	import mx.collections.ArrayList;
	import mx.collections.IList;
	
	public class DefaultLegendRenderer extends Sprite
	{
		public static const HORIZONTAL_BAR:String = 'horizontalBar';
		public static const VERTICAL_BAR:String = 'verticalBar';
		public static const LINE:String = 'line';
		public static const PIE:String = 'pie';
		public static const DOUGHNUT:String = 'doughnut';
		
		private var _valueField:String = "value";
		private var _dataSeriesField:String = "data";
		private var _labelField:String = "label";
		private var _fillField:String = "fill";
		
		public function DefaultLegendRenderer()
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
			_data = value;			
			draw();

		}
		
		public function draw():void{
			if(data.type == HORIZONTAL_BAR || data.type == VERTICAL_BAR || data.type == PIE || data.type == DOUGHNUT) {
				//get fill for bar or pie, doughnut
				var getFill:String = (data.fill == null) ? '#DC2400' : data.fill;
				var fill:uint = (getFill.search('#') == 0) ? uint(getFill.replace('#', '0x')) : uint(getFill);
				//draw legend
				var rect:Sprite = new Sprite();
				rect.graphics.beginFill(fill, 1);
				rect.graphics.drawRect(0, 0, 15, 15);
				rect.graphics.endFill();
				addChild(rect);
				//add title for bar or label for pie, doughnut
				var labelTxtField:TextField = new TextField();
				labelTxtField.text = data.label;
				labelTxtField.x = 17;
				labelTxtField.height = 20;
				labelTxtField.width = labelTxtField.textWidth + 10;
				addChild(labelTxtField);
			}else if(data.type == LINE) {
				//get stroke for line
				var getStroke:String = (data.stroke == null) ? '0x3f9b90' : data.stroke;
				var stroke:uint = (getStroke.search('#') == 0) ? uint(getStroke.replace('#', '0x')) : uint(getStroke);
				//draw legend for line series
				var line:Sprite = new Sprite();
				line.graphics.lineStyle(2, stroke);
				line.graphics.moveTo(0, 0);
				line.graphics.lineTo(15, 0);
				line.graphics.endFill();
				line.y = 8;
				addChild(line);
				//add title for line
				var titleLine:TextField = new TextField();
				titleLine.text = data.label;
				titleLine.x = 17;
				titleLine.y = 0;
				titleLine.height = 20;
				titleLine.width = titleLine.textWidth + 10;
				addChild(titleLine);
			}
			

		}

	}
}