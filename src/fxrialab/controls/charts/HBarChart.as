package fxrialab.controls.charts
{	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import mx.charts.chartClasses.ChartState;
	import mx.collections.IList;
	import mx.core.UIComponent;
	
	import spark.components.supportClasses.SkinnableComponent;
	
	public class HBarChart extends SkinnableComponent
	{
		private var _offSet:Number;
		private var _gap:Number;
		private var _dataProvider:IList;
		private var redrawSkin:Boolean = false;
		
		private var _labelField:String = "label";
		private var _valueField:String = "value";
		private var _fillField:String = "fill";
		private var _data:Object;
		
		private var marginTop:Number = 20;
		private var marginRight:Number = 10;
		private var marginBottom:Number = 10;
		private var marginLeft:Number = 10;
		
		public var hBars:Array = [];
		
		[SkinPart]
		public var hBarHolder:UIComponent;
		
		public function HBarChart(){
			super();
			this.setStyle('skinClass', HBarChartSkin);
			mouseChildren = true;
		}

		public function get dataProvider():IList
		{
			return _dataProvider;
		}
		
		private var sumValue:int = 0;

		public function set dataProvider(value:IList):void
		{
			if(value == _dataProvider) return;
			
			_dataProvider = value;
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
			
			if(redrawSkin && skin && hBarHolder) {
				redrawSkin = false;
				if(hBars.length > 0){
					for(var i:int=0; i < hBars.length; i++){
						var hBar:Sprite = hBars[i] as Sprite;
					}
					hBarHolder.removeChild(hBar);
				}
				hBars = [];
				for(i=0; i < dataProvider.length; i++){
					var hbsp:HBarSprite = new HBarSprite();
					hbsp.data = dataProvider.getItemAt(i);
					hBarHolder.addChild(hbsp);
					hBars.push(hbsp);
				}
				
				if(skin){
					skin.invalidateDisplayList();
					skin.invalidateProperties();
					
				}
			}
		}
			
		override protected function updateDisplayList(w:Number, h:Number):void
		{
			super.updateDisplayList(w, h);
			
			var barWidth:Number;
			for(var i:int=0; i < dataProvider.length; i++){	
				//update data
				var bar:HBarSprite = hBars[i] as HBarSprite;
				bar.data = dataProvider.getItemAt(i);
				bar.data.sumValue = sumValue;
				
				var getFill:Object = dataProvider.getItemAt(i);
				var fill:String = (getFill[fillField] == null) ? '#DC2400': getFill[fillField];
				var fillColor:String = (fill.search('#') == 0 || fill.search('#') == fill.indexOf(',')+1 || fill.search('#') == fill.indexOf(',')+2) ? fill.replace('#', '0x') : fill;
				bar.data.fill = fillColor;
				trace(fillColor);
				bar.data.offSet = _offSet;
				bar.data.gap = _gap;
				bar.data.gapSum = _gap * i;
				bar.data.width = w;
				bar.data.height = h;
				barWidth = ((w - (marginRight + marginLeft)) - (_offSet *2 + _gap*(dataProvider.length - 1)))/dataProvider.length;
				bar.data.barWidth = barWidth;
				bar.data.barWidthSum  = barWidth * i;

				bar.data.marginLeft = marginLeft;
				bar.data.marginRight = marginRight;
				bar.data.marginBottom = marginBottom
				//draw
				bar.draw();
			}
		}
				
		private function handlerHBarMouseEvents(evt:MouseEvent):void{
			
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

		public function get fillField():String
		{
			return _fillField;
		}

		public function set fillField(value:String):void
		{
			_fillField = value;
			redrawSkin = true;
			invalidateProperties();
		}

		
	}
}