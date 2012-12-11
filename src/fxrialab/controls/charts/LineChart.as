package fxrialab.controls.charts
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import mx.collections.IList;
	import mx.core.UIComponent;
	
	import spark.components.supportClasses.SkinnableComponent;
	
	public class LineChart extends SkinnableComponent
	{
		private var _offSet:Number;
		private var _gap:Number;
		private var _dataProvider:IList;
		private var redrawSkin:Boolean = false;
		private var _labelField:String = "label";
		private var _valueField:String = "value";
		private var _stroke:uint;
		private var _data:Object;
		private var _direction:String = "horizontal";
		
		private var marginTop:Number = 30;
		private var marginRight:Number = 10;
		private var marginBottom:Number = 10;
		private var marginLeft:Number = 10;
		
		public var lines:Array = [];
		
		[SkinPart]
		public var lineHolder:UIComponent;
		
		public function LineChart()
		{
			super();
			this.setStyle("skinClass", LineChartSkin);
		}
		
		public function get dataProvider():IList {
			return _dataProvider;
		}
		
		private var sumValue:int = 0;
		
		public function set dataProvider(value:IList):void {
			if(value == _dataProvider) return;
			
			this._dataProvider = value;
			redrawSkin = true;
			invalidateProperties();			
			
			

			for(var j:int=0; j <dataProvider.length; j++){
				data = dataProvider.getItemAt(j);
				sumValue += data[valueField];
			}
			
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			
			if(redrawSkin && skin && lineHolder){
				redrawSkin = false;
				if (lines.length > 0) {
					for ( var i:int = 0; i < lines.length; i++) {
						var line:Sprite = lines[i] as Sprite;
						line.removeEventListener(MouseEvent.MOUSE_DOWN, handlerLineMouseEvents);
						line.removeEventListener(MouseEvent.ROLL_OVER, handlerLineMouseEvents);
					}
					lineHolder.removeChild(line);
				}
				
				lines = [];
				for (i = 0; i < dataProvider.length; i++) {
					var lsp:LineSprite = new LineSprite();
					lsp.data = dataProvider.getItemAt(i);
					
					lsp.addEventListener(MouseEvent.MOUSE_DOWN, handlerLineMouseEvents, false, 0, true);
					lsp.addEventListener(MouseEvent.ROLL_OVER, handlerLineMouseEvents, false, 0, true);
					
					lineHolder.addChild(lsp);
					lines.push(lsp);
				}
				
				if(skin){
					skin.invalidateProperties();
					skin.invalidateDisplayList();
				}
			}
		}
		
		override protected function updateDisplayList(w:Number, h:Number):void
		{
			super.updateDisplayList(w, h);
			
			var barWidth:Number;
			var barHeight:Number;
			for(var i:int=0; i < dataProvider.length; i++){	
				//update data
				var line:LineSprite = lines[i] as LineSprite;
				line.data = dataProvider.getItemAt(i);
				line.data.sumValue = sumValue;
				
				line.data.offSet = _offSet;
				
				line.data.gap = _gap;
				line.data.gapSum = _gap*i;
				
				line.data.width = w;
				line.data.height = h;
				
				barWidth = (w - (marginRight + marginLeft) - (_offSet *2 + _gap*(dataProvider.length - 1)))/dataProvider.length;
				barHeight = (h - (marginBottom + marginTop) - (_offSet * 2 + _gap * (dataProvider.length - 1))) / dataProvider.length;

				line.data.barWidth = barWidth;
				line.data.barWidthSum = barWidth * i;
				
				line.data.barHeight = barHeight;
				line.data.barHeightSum = barHeight*i;
				
				line.data.stroke = stroke;
				
				line.data.marginBottom = marginBottom;
				line.data.marginLeft = marginLeft;	
				line.data.valueField = valueField;
				//determine direction for line based on coordinate axis
				line.data.direction = direction;
				//draw
				line.draw();
			}
		}
		
		private function handlerLineMouseEvents(evt:MouseEvent):void {
			var line:LineSprite = evt.target as LineSprite;
			
			switch(evt.type){
				case MouseEvent.ROLL_OVER:
						line.showTooltip();
						line.addEventListener(MouseEvent.ROLL_OUT, handlerLineMouseEvents);
					break;
				case MouseEvent.ROLL_OUT:
						line.removeEventListener(MouseEvent.ROLL_OUT, handlerLineMouseEvents);
						line.hideTooltip();
					break;
			}
		}
		
		public function get labelField():String
		{
			return _labelField;
		}
		
		public function set labelField(value:String):void
		{
			_labelField = value;
		}
		
		public function get valueField():String
		{
			return _valueField;
		}
		
		public function set valueField(value:String):void
		{
			_valueField = value;
		}
		
		public function get data():Object
		{
			return _data;
		}
		
		public function set data(value:Object):void
		{
			_data = value;
		}

		public function get direction():String
		{
			return _direction;
		}

		public function set direction(value:String):void
		{
			_direction = value;
			invalidateDisplayList();
		}
		
		public function get offSet():Number
		{
			return _offSet;
		}
		
		public function set offSet(value:Number):void
		{
			_offSet = value;
			redrawSkin = true;
			invalidateProperties();
		}
		
		public function get gap():Number
		{
			return _gap;
		}
		
		public function set gap(value:Number):void
		{
			_gap = value;
			redrawSkin = true;
			invalidateProperties();
		}

		public function get stroke():uint
		{
			return _stroke;
		}

		public function set stroke(value:uint):void
		{
			_stroke = value;
		}


	}
}