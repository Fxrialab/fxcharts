package fxrialab.controls.charts 
{
	import flash.display.Sprite;
	
	import mx.collections.ArrayList;
	import mx.collections.IList;
	import mx.core.UIComponent;
	
	import spark.components.supportClasses.SkinnableComponent;
	
	public class VBarChart extends SkinnableComponent 
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
		private var _barHeight:Number;
		private var _seriesChartNumber:Number;
		
		public var vBars:Array = [];
		
		[SkinPart]
		public var vBarHolder:UIComponent;
		
		public function VBarChart() 
		{
			super();		
			this.setStyle('skinClass', VBarChartSkin);
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
				
			for (var j:int = 0; j < dataProvider.length; j++) {
				data = dataProvider.getItemAt(j);
				sumValue += data[valueField];
			}
			
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			
			if(redrawSkin && skin && vBarHolder){
				redrawSkin = false;
				if (vBars.length > 0) {
					for (var i:int = 0; i < vBars.length; i++) {
						var vBar:Sprite = vBars[i] as Sprite;
					}
					vBarHolder.removeChild(vBar);
				}
				vBars = [];
				if (type == FxChart.STACKED) {
					for(i=0; i < dataProvider.length; i++) {
						var arr:IList = new ArrayList(dataProvider.getItemAt(i) as Array);
						for (var j:int=0; j < arr.length; j++) {
							var sbsp:VBarStackedSprite = new VBarStackedSprite();
							sbsp.data = arr.getItemAt(j);
							
							vBarHolder.addChild(sbsp);
							vBars.push(sbsp);
						}
					}
				}else {
					for (i = 0; i < dataProvider.length; i++) {
						var vbsp:VBarSprite = new VBarSprite();
						vbsp.data = dataProvider.getItemAt(i);
						vBarHolder.addChild(vbsp);
						vBars.push(vbsp);
					}
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
			
			if (type == FxChart.STACKED) {
				for(var i:int=0; i < dataProvider.length; i++){
					var arrList:IList = new ArrayList(dataProvider.getItemAt(i) as Array);
					for (var j:int=0; j < arrList.length; j++) {
						//update data
						var sbar:VBarStackedSprite = vBars[j] as VBarStackedSprite;
						sbar.data = arrList.getItemAt(j);
						
						sbar.data.font = getStyle('fontDefault');
						sbar.data.size = getStyle('sizeDefault');
						sbar.data.align = getStyle('leftAlign');
						
						sbar.data.gapCalc = _gap * j;
						sbar.data.offSet = _offSet;
						
						sbar.data.width = w;
						sbar.data.height = h;
						sbar.data.barHeight = barHeight;
						sbar.data.barHeightCalc = barHeight * j;
						
						sbar.data.maxValue = maxValue;
						sbar.data.minValue = minValue;
						sbar.data.marginTop = marginTop;
						sbar.data.marginLeft = marginLeft;
						sbar.data.marginBottom = marginBottom;
						//draw
						sbar.draw();
					}
				}
			}else {
				for(i=0; i < dataProvider.length; i++){	
					//update data
					var bar:VBarSprite = vBars[i] as VBarSprite;
					bar.data = dataProvider.getItemAt(i);
					bar.data.sumValue = sumValue;

					bar.data.font = getStyle('fontDefault');
					bar.data.size = getStyle('sizeDefault');
					bar.data.align = getStyle('leftAlign');
					bar.data.fill = fill;
					
					bar.data.gapCalc = _gap * i;
					bar.data.offSet = _offSet;
					
					bar.data.width = w;
					bar.data.height = h;
					bar.data.seriesChartNum = seriesChartNumber;
					bar.data.barHeight = (type == FxChart.CLUSTERED) ? barHeight/seriesChartNumber : barHeight;
					bar.data.barHeightCalc = barHeight * i;
					
					bar.data.maxValue = maxValue;
					bar.data.minValue = minValue;
					bar.data.marginTop = marginTop;
					bar.data.marginLeft = marginLeft;
					bar.data.marginBottom = marginBottom;
					//draw
					bar.draw();
				}
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

		public function get barHeight():Number
		{
			return _barHeight;
		}

		public function set barHeight(value:Number):void
		{
			_barHeight = value;
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


	}

}