package fxrialab.controls.charts
{	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import mx.charts.chartClasses.ChartState;
	import mx.collections.ArrayList;
	import mx.collections.IList;
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	
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
		private var _fill:uint;
		private var _type:String;
		
		private var _marginTop:Number;
		private var _marginRight:Number;
		private var _marginBottom:Number;
		private var _marginLeft:Number;
		
		private var _maxValue:Number;
		private var _minValue:Number;
		private var _barWidth:Number;
		private var _seriesChartNumber:Number;
		
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
			//invalidateDisplayList();
			
		}
		
		private var redrawSprite:Boolean = false;
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			
			/*if (hBarHolder.numChildren > 0)
				hBarHolder.removeChildren();*/
			
			if(redrawSkin && skin && hBarHolder) {
				redrawSkin = false;
				if (hBarHolder.numChildren > 0)
					hBarHolder.removeChildren();
				
				if(hBars.length > 0)
				{
					
					for(var i:int=0; i < hBars.length; i++)
					{
						var hBar:Sprite = hBars[i] as Sprite;
						//hBar.graphics.clear();
						hBar.removeEventListener(MouseEvent.MOUSE_DOWN, handlerHBarMouseEvents);
						hBar.removeEventListener(MouseEvent.ROLL_OVER, handlerHBarMouseEvents);
						//hBarHolder.removeChild(hBar);
					}
					
				}
				hBars = [];
				if (type == FxChart.STACKED) 
				{
					for(var i:int=0; i < dataProvider.length; i++) {
						var arr:IList = new ArrayList(dataProvider.getItemAt(i) as Array);
						for (var j:int=0; j < arr.length; j++) {
							var sbsp:HBarStackedSprite = new HBarStackedSprite();
							sbsp.data = arr.getItemAt(j);
							
							//sbsp.addEventListener(MouseEvent.MOUSE_DOWN, handlerHBarMouseEvents, false, 0, true);
							//sbsp.addEventListener(MouseEvent.ROLL_OVER, handlerHBarMouseEvents, false, 0, true);
							
							hBarHolder.addChild(sbsp);
							hBars.push(sbsp);
						}
					}
				}else {
					for(i=0; i < dataProvider.length; i++){
						var hbsp:HBarSprite = new HBarSprite();

						hbsp.data = dataProvider.getItemAt(i);
						
						//hbsp.addEventListener(MouseEvent.MOUSE_DOWN, handlerHBarMouseEvents, false, 0, true);
						//hbsp.addEventListener(MouseEvent.ROLL_OVER, handlerHBarMouseEvents, false, 0, true);
						//hbsp.addEventListener(FlexEvent.CREATION_COMPLETE, onCreateCompleteEvent, false, 0, true);
						
						hBarHolder.addChild(hbsp);
						hBars.push(hbsp);
					}
				}
				
				if(skin){
					skin.invalidateDisplayList();
					skin.invalidateProperties();
					
				}
			}
			/*if (redrawSkin == false)
				redrawSprite = true;*/
		}
			
		override protected function updateDisplayList(w:Number, h:Number):void
		{
			super.updateDisplayList(w, h);
			//trace(dataProvider.length);
			//redrawSprite = true;
			if (type == FxChart.STACKED) 
			{
				for (var i:int = 0; i < dataProvider.length; i++) 
				{
					var arrList:IList = new ArrayList(dataProvider.getItemAt(i) as Array);

					for (var j:int=0; j < arrList.length; j++) {
						var sb:HBarStackedSprite = hBars[j] as HBarStackedSprite;
						sb.data = arrList.getItemAt(j);
						sb.data.barWidth = barWidth;
						sb.data.offSet = _offSet;
						sb.data.gap = _gap;
						sb.data.gapSum = _gap * j;
						sb.data.width = w;
						sb.data.height = h;
						
						sb.data.barWidthSum  = barWidth * j;
						
						sb.data.marginLeft = marginLeft;
						sb.data.marginRight = marginRight;
						sb.data.marginBottom = marginBottom;
						
						sb.data.minValue = minValue;
						sb.data.maxValue = maxValue;
						
						sb.draw();
					}
				}
			}else {
				for (i = 0; i < dataProvider.length; i++)
				{
					//update data
					var bar:HBarSprite = hBars[i] as HBarSprite;

					bar.data = dataProvider.getItemAt(i);
					bar.data.sumValue = sumValue;
					bar.data.redraw = redrawSprite;
					bar.data.font = getStyle('fontDefault');
					bar.data.size = getStyle('sizeDefault');
					bar.data.align = getStyle('alignDefault');
					bar.data.fill = fill;
					
					bar.data.offSet = _offSet;
					bar.data.gap = _gap;
					bar.data.gapSum = _gap * i;
					bar.data.width = w;
					bar.data.height = h;
					bar.data.seriesChartNumber = seriesChartNumber;
					//trace('type of bar', seriesChartNumber);
					bar.data.barWidth = (type == FxChart.CLUSTERED) ? barWidth/seriesChartNumber : barWidth;
					bar.data.barWidthSum  = barWidth * i;
					
					bar.data.marginLeft = marginLeft;
					bar.data.marginRight = marginRight;
					bar.data.marginBottom = marginBottom;
					
					bar.data.minValue = minValue;
					bar.data.maxValue = maxValue;
					//draw
					
					bar.draw();	
				}
			}
		}
		
		private function onCreateCompleteEvent(evt:FlexEvent):void
		{
			redrawSprite = true;
		}
				
		private function handlerHBarMouseEvents(evt:MouseEvent):void
		{
			var hBar:HBarSprite = evt.target as HBarSprite;
			
			switch(evt.type)
			{
				case MouseEvent.MOUSE_DOWN:
						
					break;
				case MouseEvent.ROLL_OVER:
						hBar.showTooltip();
						hBar.addEventListener(MouseEvent.ROLL_OUT, handlerHBarMouseEvents);
					break;
				case MouseEvent.ROLL_OUT:
						hBar.hideTooltip();
						hBar.removeEventListener(MouseEvent.ROLL_OUT, handlerHBarMouseEvents);
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
		
		public function get marginTop():Number 
		{
			return _marginTop;
		}
		
		public function set marginTop(value:Number):void 
		{
			_marginTop = value;
			redrawSkin = true;
			invalidateProperties();
		}
		
		public function get marginRight():Number 
		{
			return _marginRight;
		}
		
		public function set marginRight(value:Number):void 
		{
			_marginRight = value;
			redrawSkin = true;
			invalidateProperties();
		}
		
		public function get marginBottom():Number 
		{
			return _marginBottom;
		}
		
		public function set marginBottom(value:Number):void 
		{
			_marginBottom = value;
			redrawSkin = true;
			invalidateProperties();
		}
		
		public function get marginLeft():Number 
		{
			return _marginLeft;
		}
		
		public function set marginLeft(value:Number):void 
		{
			_marginLeft = value;
			redrawSkin = true;
			invalidateProperties();
		}

		public function get maxValue():Number
		{
			return _maxValue;
		}

		public function set maxValue(value:Number):void
		{
			_maxValue = value;
			redrawSkin = true;
			invalidateProperties();
		}

		public function get minValue():Number
		{
			return _minValue;
		}

		public function set minValue(value:Number):void
		{
			_minValue = value;
			redrawSkin = true;
			invalidateProperties();
		}

		public function get fill():uint
		{
			return _fill;
		}

		public function set fill(value:uint):void
		{
			_fill = value;
		}

		public function get type():String
		{
			return _type;
		}

		public function set type(value:String):void
		{
			_type = value;
			redrawSkin = true;
			invalidateProperties();
		}

		public function get barWidth():Number
		{
			return _barWidth;
		}

		public function set barWidth(value:Number):void
		{
			_barWidth = value;
			redrawSkin = true;
			invalidateProperties();
		}

		public function get seriesChartNumber():Number
		{
			return _seriesChartNumber;
		}

		public function set seriesChartNumber(value:Number):void
		{
			_seriesChartNumber = value;
			redrawSkin = true;
			invalidateProperties();
		}

		
	}
}