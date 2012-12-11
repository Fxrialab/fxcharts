package fxrialab.controls.charts 
{
	import flash.events.MouseEvent;
	import flash.display.Sprite;
	import flash.display.GradientType;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.geom.Point;
	
	import fxrialab.utils.DrawHelper;
	
	public class DoughnutSprite extends Sprite 
	{
		public function DoughnutSprite() 
		{
			super();
			mouseChildren = true;
		}
		
		private var _data:Object;
		private var origin:Point;
		private var _getFill:Object;
		
		public function get getFill():Object
		{
			return _getFill;
		}

		public function set getFill(value:Object):void
		{
			if(_getFill == value) return;
			_getFill = value;
		}
		
		public function get data():Object {
			return _data;
		}
		
		public function set data(value:Object):void {
			if (_data == value) return;
			_data = value;
		}
		
		public function draw():void {
			var commandsData:Vector.<Object> = DrawHelper.SolidArc(data.centerX, data.centerY, data.innerRadius, data.outerRadius, data.startAngle, data.arcData);
			var cmds:Vector.<int> = new Vector.<int>();
			var pts:Vector.<Number> = new Vector.<Number>();
			
			for (var i:int = 0; i < commandsData.length; i++) {
				var data:Object = commandsData[i];
				cmds.push(int(data.command));
				pts.push(Number(data.x), Number(data.y));
			}
			
			var gradType:String = GradientType.LINEAR;
			var colors:Array = [];
			var alphas:Array = [1, 1];
			var ratios:Array = [0, 255];
			
			this.graphics.clear();
			this.graphics.lineStyle(2, 0xffffff);
			if (getFill.color.search(',') == -1) {
				this.graphics.beginFill(getFill.color, 1);
			}else {
				var getGradientColor:String = getFill.color;
				var getFirstColor:uint = uint(getGradientColor.substring(0, getGradientColor.indexOf(',')));
				var getSecondColor:uint = uint(getGradientColor.substring(getGradientColor.indexOf(',')+1, getGradientColor.length));
				colors.push(getFirstColor, getSecondColor);

				this.graphics.beginGradientFill(gradType, colors, alphas, ratios);
			}
			this.graphics.drawPath(cmds, pts);
			this.graphics.endFill();
		}
		
		public function animate(distance:Number):void {
			var angle:Number = data.value / data.sumValue * 360/2 + data.startAngle;
			var rad:Number   = Math.PI/180*angle;

			if(origin == null){//need to explode
				var dx:Number = Math.cos(rad) * distance;
				var dy:Number = Math.sin(rad) * distance;
				origin = new Point(x, y);
				this.x = x + dx;
				this.y = y + dy;
			}else{
				this.x = origin.x;
				this.y = origin.y;
				origin = null;
			}
		}
		
		public var tooltip:Sprite;
		
		public function showTooltip():void {
			
			var txtFieldTooltip:TextField = new TextField();
			var txtFormatTooltip:TextFormat = new TextFormat();
			var calcPercent:Number = Math.ceil(data.value/data.sumValue * 100);
			
			txtFormatTooltip.align = 'left';
			txtFormatTooltip.font = 'Verdana';
			txtFormatTooltip.size = 10;
			txtFormatTooltip.color = 0xFFFFFF;
			txtFormatTooltip.leftMargin = txtFormatTooltip.rightMargin = 2;
			
			txtFieldTooltip.selectable = false;
			txtFieldTooltip.height = 20;
			txtFieldTooltip.wordWrap = true;
			txtFieldTooltip.multiline = true;
			txtFieldTooltip.text = data.label +":"+ calcPercent + "%";
			txtFieldTooltip.setTextFormat(txtFormatTooltip);
			
			tooltip = DrawHelper.Tooltip(txtFieldTooltip.textWidth + 10, txtFieldTooltip.height, 0x1a8948);
			tooltip.addChild(txtFieldTooltip);
			var p:Point = new Point(this.mouseX, this.mouseY);
			p = this.localToGlobal(p);
			tooltip.x = p.x - (txtFieldTooltip.textWidth + 10)/2;
			tooltip.y = p.y - tooltip.height - 1;
				
			this.stage.addChild(tooltip);
			
			addEventListener(MouseEvent.MOUSE_MOVE, moveTooltip, false, 0, true);
		}
		
		private function moveTooltip(evt:MouseEvent):void {
			if(tooltip){
				tooltip.x = evt.stageX - tooltip.width / 2;
				tooltip.y = evt.stageY - tooltip.height - 1;
			}
		}
		public function hideTooltip():void {
			if(tooltip){
				stage.removeChild(tooltip);
				tooltip = null;	
			}
		}
		
	}

}